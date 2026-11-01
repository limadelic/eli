import { remark } from "remark";
import { step } from "../elements.js";
import { bullets } from "../bullets.js";

export const id = `${step}.lines`;

export const defaults = ["error", { max: 2 }];

const body = (item) => item.children.filter((node) => node.type !== "list");

const lines = ({ position }) => position.end.line - position.start.line + 1;

const count = (item) =>
  body(item)
    .map(lines)
    .reduce((sum, n) => sum + n, 0);

const over = (max) => (item) => count(item) > max;

const hit = (max) => (item) => ({
  line: item.position.start.line,
  actual: count(item),
  max,
});

export const check = (text, { max }) =>
  bullets(remark().parse(text).children).filter(over(max)).map(hit(max));
