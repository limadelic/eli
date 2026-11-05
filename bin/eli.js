#!/usr/bin/env node
import fs from "node:fs";
import { homedir } from "node:os";
import { relative } from "node:path";
import { configure, invalid, load, unknown } from "../lib/config.js";
import { blank, frontmatter } from "../lib/frontmatter.js";
import { targets } from "../lib/targets.js";

const argv = process.argv.slice(2);
const cwd = process.cwd();
const names = argv.filter((arg, i) => ![arg, argv[i - 1]].includes("--config"));
const home = fs.realpathSync(homedir());
const settings = load(argv, cwd, home);
const active = configure(settings);
const bad = invalid(argv, cwd, home);
const gone = unknown(argv, cwd, home);

const fire =
  (text) =>
  ({ id, check, max }) =>
    check(text, max).map((hit) => ({ id, ...hit }));

const scan = (text) => [
  ...active.flatMap(fire(blank(text))),
  ...frontmatter(text),
];

const lint = (file) =>
  scan(fs.readFileSync(file, "utf8")).map((hit) => ({
    ...hit,
    path: relative(cwd, file),
  }));

const detail = ({ actual, max }) =>
  [actual, max].filter((part) => part !== undefined).join(" > ");

const found = bad.length ? [] : targets(names).flatMap(lint);

bad.forEach(({ path, id, value }) =>
  console.log(
    `${relative(cwd, path)} ${id}: invalid value ${JSON.stringify(value)}`,
  ),
);
gone.forEach(({ path, id }) =>
  console.log(`${relative(cwd, path)} unknown rule ${id}`),
);
found.forEach((hit) =>
  console.log(`${hit.path}:${hit.line} ${hit.id}`, detail(hit)),
);

process.exitCode = Math.max(
  0,
  ...bad.map(() => 2),
  ...gone.map(() => 2),
  ...found.map(() => 1),
);
