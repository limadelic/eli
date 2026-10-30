#!/usr/bin/env node
import fs from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";
import { lines } from "../lib/lines.js";

const skills = join(homedir(), ".claude", "skills");

const read = (path) => fs.readFileSync(join(skills, path), "utf8");

const rules = [lines];

const check = (name) => {
  const text = read(`${name}/SKILL.md`);
  const limits = read("elle/limits.md");
  return rules.flatMap((rule) => rule(name, text, limits));
};

const report = (found) => {
  found.forEach((line) => console.log(line));
  process.exitCode = found.length;
};

report(check(process.argv[2]));
