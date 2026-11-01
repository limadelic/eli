import fs from "node:fs";
import { join } from "node:path";
import { parse } from "yaml";
import { kinds, rules } from "./rules/index.js";
import { section } from "./elements.js";
import { valid } from "./values.js";

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
  sources(argv, cwd, home).map(read).map(flat);

export const load = (argv, cwd, home) =>
  Object.fromEntries(layers(argv, cwd, home).reverse().flat());

const known = [
  ...kinds.flatMap((kind) => [
    `${kind}.${section}.width`,
    `${kind}.${section}.steps`,
  ]),
  ...kinds.flatMap((kind) => rules(kind, {}).map((rule) => rule.id)),
  `${section}.width`,
  ...kinds,
];

export const unknown = (settings) =>
  Object.keys(settings).filter((id) => !known.includes(id));

const wrong = ([id, value]) =>
  [kinds.includes(id), !valid(value)].some(Boolean);

export const invalid = (settings) =>
  Object.entries(settings)
    .filter(([id]) => known.includes(id))
    .filter(wrong);

const defaults = (list) =>
  Object.fromEntries(list.map((rule) => [rule.id, rule.defaults]));

const options = (rule, given) => Object.assign({}, rule.defaults[1], ...given);

const entry = (rule, value) => {
  const [severity, ...given] = [value].flat();
  return { rule, severity, options: options(rule, given) };
};

const active = ({ severity }) => severity !== "off";

export const configure = (settings, kind) => {
  const list = rules(kind, settings);
  const merged = Object.assign({}, defaults(list), settings);
  return list.map((rule) => entry(rule, merged[rule.id])).filter(active);
};
