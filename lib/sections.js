import { remark } from "remark";
import { limit } from "./limit.js";

const level = (text) =>
  remark()
    .parse(text)
    .children.filter((node) => node.depth === 2);

const message = (name, n, max) => (heading) =>
  `${name}/SKILL.md:${heading.position.start.line} sections ${n} > ${max}`;

export const sections = (name, text, limits) => {
  const max = limit(limits, "sections");
  const heads = level(text);
  return heads.slice(max, max + 1).map(message(name, heads.length, max));
};
