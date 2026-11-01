#!/usr/bin/env node
import fs from "node:fs";
import { homedir } from "node:os";
import { relative } from "node:path";
import { configure, invalid, load, unknown } from "../lib/config.js";
import { kind } from "../lib/elements.js";
import { targets } from "../lib/targets.js";
import { shaped } from "../lib/values.js";

const argv = process.argv.slice(2);
const cwd = process.cwd();
const names = argv.filter((arg, i) => ![arg, argv[i - 1]].includes("--config"));
const home = fs.realpathSync(homedir());
const settings = load(argv, cwd, home);
const bad = invalid(argv, cwd, home);
const gone = unknown(argv, cwd, home);

const fire =
  (text, values) =>
  ({ rule, severity, options }) =>
    rule
      .check(text, options, values)
      .map((hit) => ({ id: rule.id, severity, ...hit }));

const lint = (values) => (file) =>
  configure(values, kind(file))
    .flatMap(fire(fs.readFileSync(file, "utf8"), values))
    .map((hit) => ({ ...hit, path: relative(cwd, file) }));

const found = bad.length ? [] : targets(names).flatMap(lint(shaped(settings)));

const label = { warn: "warn ", error: "" };

bad.forEach(({ path, id, value }) =>
  console.log(
    `${relative(cwd, path)} ${id}: invalid value ${JSON.stringify(value)}`,
  ),
);
gone.forEach(({ path, id }) =>
  console.log(`${relative(cwd, path)} unknown rule ${id}`),
);
found.forEach((hit) =>
  console.log(
    `${hit.path}:${hit.line} ${label[hit.severity]}${hit.id}`,
    `${hit.actual} > ${hit.max}`,
  ),
);

process.exitCode = Math.max(
  0,
  ...bad.map(() => 2),
  ...gone.map(() => 2),
  ...found.filter((hit) => hit.severity === "error").map(() => 1),
);
