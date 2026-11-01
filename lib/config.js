import fs from "node:fs";
import { join } from "node:path";
import { parse } from "yaml";
import { rules } from "./rules/index.js";
import { skill, section } from "./elements.js";

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

const shapes = {
  number: (max) => ["error", { max }],
  object: ([severity, max]) => [severity, { max }],
  string: (off) => off,
};

const shape = (value) => shapes[typeof value](value);

const leaf = (key, value) => [[key, value]];

const props = (key, value) =>
  Object.entries(value).flatMap(([prop, given]) =>
    children[element(given)](`${key}.${prop}`, given),
  );

const shaped = (key, value) => [[key, shape(value)]];

const children = { true: props, false: shaped };

const kinds = { true: props, false: leaf };

const element = (value) =>
  Object.prototype.toString.call(value) === "[object Object]";

const pairs = ([key, value]) => kinds[element(value)](key, value);

const flat = (settings) => Object.entries(settings).flatMap(pairs);

export const load = (argv, cwd, home) =>
  Object.fromEntries(
    sources(argv, cwd, home).slice(0, 1).map(read).flatMap(flat),
  );

const known = [
  ...rules.map((rule) => rule.id),
  `${section}.width`,
  `${skill}.${section}.width`,
];

export const unknown = (settings) =>
  Object.keys(settings).filter((id) => !known.includes(id));

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
