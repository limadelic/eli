import { limit } from "./limit.js";

const count = (text) => text.split("\n").length - 1;

const message = (name, n, max) => `${name}/SKILL.md:${n} lines ${n} > ${max}`;

export const lines = (name, text, limits) => {
  const max = limit(limits, "lines");
  const n = count(text);
  return [message(name, n, max)].slice(0, Number(n > max));
};
