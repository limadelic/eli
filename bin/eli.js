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
const settings = load(argv, cwd, homedir());
const values = shaped(settings);

const fire =
  (text) =>
  ({ rule, severity, options }) =>
    rule
      .check(text, options, values)
      .map((hit) => ({ id: rule.id, severity, ...hit }));

const lint = (file) =>
  configure(values, kind(file))
    .flatMap(fire(fs.readFileSync(file, "utf8")))
    .map((hit) => ({ ...hit, path: relative(cwd, file) }));

const bad = invalid(settings);
const found = bad.length ? [] : targets(names).flatMap(lint);

const label = { warn: "warn ", error: "" };

bad.forEach(([id, value]) =>
  console.log(`.eli.yml ${id}: invalid value ${value}`),
);
unknown(settings).forEach((id) => console.log(`.eli.yml unknown rule ${id}`));
found.forEach((hit) =>
  console.log(
    `${hit.path}:${hit.line} ${label[hit.severity]}${hit.id}`,
    `${hit.actual} > ${hit.max}`,
  ),
);

process.exitCode = Math.max(
  0,
  ...bad.map(() => 2),
  ...unknown(settings).map(() => 2),
  ...found.filter((hit) => hit.severity === "error").map(() => 1),
);
