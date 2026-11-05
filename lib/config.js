import fs from "node:fs";
import { join, resolve } from "node:path";
import { parse } from "yaml";
import { rules } from "./rules/index.js";
import { level, valid } from "./values.js";

const file = ".eli.yml";

const known = Object.keys(rules);

const defaults = Object.fromEntries(
  Object.entries(rules).map(([id, rule]) => [id, rule.value]),
);

const exists = (path) => [path].filter((p) => fs.existsSync(p));

const flagged = (argv, cwd) =>
  argv
    .filter((arg, i) => argv[i - 1] === "--config")
    .map((path) => resolve(cwd, path));

const prefix = (parts) => (part, i) =>
  parts.slice(0, parts.length - i).join("/");

const ancestors = (dir) => {
  const parts = dir.split("/");
  return [...parts.map(prefix(parts)).filter(Boolean), "/"];
};

const project = (cwd) =>
  ancestors(cwd).flatMap((dir) => exists(join(dir, file)));

const sources = (argv, cwd, home) => [
  ...flagged(argv, cwd),
  ...project(cwd),
  ...exists(join(home, ".claude", "skills", file)),
];

const read = (path) => Object.assign({}, parse(fs.readFileSync(path, "utf8")));

const layers = (argv, cwd, home) =>
  [...new Set(sources(argv, cwd, home))].map((path) => ({
    path,
    pairs: Object.entries(read(path)),
  }));

const entries = ({ pairs }) => pairs;

const merged = (argv, cwd, home) =>
  Object.fromEntries(layers(argv, cwd, home).reverse().flatMap(entries));

export const load = (argv, cwd, home) =>
  Object.assign({}, defaults, merged(argv, cwd, home));

const dropped = ({ path, pairs }) =>
  pairs.filter(([id]) => !known.includes(id)).map(([id]) => ({ path, id }));

export const unknown = (argv, cwd, home) =>
  layers(argv, cwd, home).flatMap(dropped);

const checked = ({ path, pairs }) =>
  pairs
    .filter(([id]) => known.includes(id))
    .filter(([id, value]) => !valid(id, value))
    .map(([id, value]) => ({ path, id, value }));

export const invalid = (argv, cwd, home) =>
  layers(argv, cwd, home).flatMap(checked);

const setting = (settings, [id, { check }]) => ({
  id,
  check,
  level: level(settings[id]),
});

export const configure = (settings) =>
  Object.entries(rules).map((pair) => setting(settings, pair));
