import fs from "node:fs";
import { join } from "node:path";

const patterns = [/(^|\/)SKILL\.md$/, /(^|\/)agents\/[^/]+\.md$/];

const lintable = (file) => patterns.some((re) => re.test(file));

const isdir = (arg) => fs.statSync(arg).isDirectory();

const walk = (dir) =>
  fs
    .readdirSync(dir, { recursive: true })
    .sort()
    .map((file) => join(dir, file));

const expand = { true: walk, false: (file) => [file] };

export const targets = (args) =>
  args.flatMap((arg) => expand[isdir(arg)](arg)).filter(lintable);
