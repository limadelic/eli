#!/usr/bin/env node
import fs from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";

const skills = join(homedir(), ".claude", "skills");

const read = (path) => fs.readFileSync(join(skills, path), "utf8");

const limit = () => Number(read("elle/limits.md").match(/max (\d+) lines/)[1]);

const count = (text) => text.split("\n").length - 1;

const check = (name, max) => {
  const lines = count(read(`${name}/SKILL.md`));
  const over = [`${name}/SKILL.md:${lines} lines ${lines} > ${max}`];
  return over.slice(0, Number(lines > max));
};

const report = (found) => {
  found.forEach((line) => console.log(line));
  process.exitCode = found.length;
};

report(check(process.argv[2], limit()));
