import fs from "node:fs";
import { join } from "node:path";
import { parse } from "yaml";
import { rules } from "./rules/index.js";

const file = ".eli.yml";

const exists = (path) => [path].filter((p) => fs.existsSync(p));

const flagged = (argv) => argv.filter((arg, i) => argv[i - 1] === "--config");

const prefix = (parts) => (part, i) =>
  parts.slice(0, parts.length - i).join("/");

const ancestors = (dir) => {
  const parts = dir.split("/");
  return [...parts.map(prefix(parts)).filter(Boolean), "/"];
};

const project = (cwd) =>
  ancestors(cwd).flatMap((dir) => exists(join(dir, file)));

const sources = (argv, cwd, home) => [
  ...flagged(argv),
  ...project(cwd),
  ...exists(join(home, ".claude", "skills", file)),
];

const read = (path) => parse(fs.readFileSync(path, "utf8"));

export const load = (argv, cwd, home) =>
  Object.assign({}, ...sources(argv, cwd, home).slice(0, 1).map(read));

export const unknown = (settings) =>
  Object.keys(settings).filter((id) => !rules.some((rule) => rule.id === id));

const defaults = Object.fromEntries(
  rules.map((rule) => [rule.id, rule.defaults]),
);

const options = (rule, given) => Object.assign({}, rule.defaults[1], ...given);

const entry = (rule, value) => {
  const [severity, ...given] = [value].flat();
  return { rule, severity, options: options(rule, given) };
};

const active = ({ severity }) => severity !== "off";

export const configure = (settings) => {
  const merged = Object.assign({}, defaults, settings);
  return rules.map((rule) => entry(rule, merged[rule.id])).filter(active);
};
