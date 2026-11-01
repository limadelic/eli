import fs from "node:fs";
import { join, resolve } from "node:path";
import { parse } from "yaml";
import { kinds, known, rules } from "./rules/index.js";
import { valid } from "./values.js";

const file = ".eli.yml";

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

const props = (key, value) =>
  Object.entries(value).flatMap(([prop, given]) =>
    forms[element(given)](`${key}.${prop}`, given),
  );

const leaf = (key, value) => [[key, value]];

const forms = { true: props, false: leaf };

const element = (value) =>
  Object.prototype.toString.call(value) === "[object Object]";

const pairs = ([key, value]) => forms[element(value)](key, value);

const flat = (settings) => Object.entries(settings).flatMap(pairs);

const layers = (argv, cwd, home) =>
  [...new Set(sources(argv, cwd, home))].map((path) => ({
    path,
    pairs: flat(read(path)),
  }));

const entries = ({ pairs }) => pairs;

export const load = (argv, cwd, home) =>
  Object.fromEntries(layers(argv, cwd, home).reverse().flatMap(entries));

const dropped = ({ path, pairs }) =>
  pairs.filter(([id]) => !known.includes(id)).map(([id]) => ({ path, id }));

export const unknown = (argv, cwd, home) =>
  layers(argv, cwd, home).flatMap(dropped);

const wrong = ([id, val]) => [kinds.includes(id), !valid(val)].some(Boolean);

const checked = ({ path, pairs }) =>
  pairs
    .filter(([id]) => known.includes(id))
    .filter(wrong)
    .map(([id, value]) => ({ path, id, value }));

export const invalid = (argv, cwd, home) =>
  layers(argv, cwd, home).flatMap(checked);

const defaults = (list) =>
  Object.fromEntries(list.map((rule) => [rule.id, rule.defaults]));

const options = (rule, given) => Object.assign({}, rule.defaults[1], ...given);

const entry = (rule, value) => {
  const [severity, ...given] = [value].flat();
  return { rule, severity, options: options(rule, given) };
};

export const configure = (settings, kind) => {
  const list = rules(kind, settings);
  const merged = Object.assign({}, defaults(list), settings);
  return list.map((rule) => entry(rule, merged[rule.id]));
};
