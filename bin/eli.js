#!/usr/bin/env node
import fs from "node:fs";
import { homedir } from "node:os";
import { relative } from "node:path";
import { configure, load, unknown } from "../lib/config.js";
import { kind } from "../lib/elements.js";
import { targets } from "../lib/targets.js";

const argv = process.argv.slice(2);
const cwd = process.cwd();
const names = argv.filter((arg, i) => ![arg, argv[i - 1]].includes("--config"));
const settings = load(argv, cwd, homedir());

const fire =
  (text) =>
  ({ rule, severity, options }) =>
    rule
      .check(text, options, settings)
      .map((hit) => ({ id: rule.id, severity, ...hit }));

const lint = (file) =>
  configure(settings, kind(file))
    .flatMap(fire(fs.readFileSync(file, "utf8")))
    .map((hit) => ({ ...hit, path: relative(cwd, file) }));

const found = targets(names).flatMap(lint);

const label = { warn: "warn ", error: "" };

unknown(settings).forEach((id) => console.log(`.eli.yml unknown rule ${id}`));
found.forEach((hit) =>
  console.log(
    `${hit.path}:${hit.line} ${label[hit.severity]}${hit.id}`,
    `${hit.actual} > ${hit.max}`,
  ),
);

process.exitCode = Math.max(
  0,
  ...unknown(settings).map(() => 2),
  ...found.filter((hit) => hit.severity === "error").map(() => 1),
);
