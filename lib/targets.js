import fs from "node:fs";
import { join } from "node:path";
import { kind } from "./elements.js";

const isdir = (arg) => fs.statSync(arg).isDirectory();

const walk = (dir) =>
  fs
    .readdirSync(dir, { recursive: true })
    .sort()
    .map((file) => join(dir, file));

const expand = { true: walk, false: (file) => [file] };

export const targets = (args) =>
  args.flatMap((arg) => expand[isdir(arg)](arg)).filter((file) => kind(file));
