#!/usr/bin/env node
import fs from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";
import { configure, load, unknown } from "../lib/config.js";

const argv = process.argv.slice(2);
const name = argv.filter(
  (arg, i) => ![arg, argv[i - 1]].includes("--config"),
)[0];
const settings = load(argv, process.cwd(), homedir());
const text = fs.readFileSync(
  join(homedir(), ".claude", "skills", name, "SKILL.md"),
  "utf8",
);

const found = configure(settings).flatMap(({ rule, severity, options }) =>
  rule.check(text, options).map((hit) => ({ ...hit, id: rule.id, severity })),
);

unknown(settings).forEach((id) => console.log(`.eli.yml unknown rule ${id}`));
found.forEach((hit) =>
  console.log(
    `${name}/SKILL.md:${hit.line} ${hit.id} ${hit.actual} > ${hit.max}`,
  ),
);

process.exitCode = Math.max(
  0,
  ...unknown(settings).map(() => 2),
  ...found.filter((hit) => hit.severity === "error").map(() => 1),
);
