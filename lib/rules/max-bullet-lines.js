import { remark } from "remark";
import { bullets } from "../bullets.js";

export const id = "max-bullet-lines";

export const defaults = ["error", { max: 2 }];

const first = (item) => item.children[0];

const lines = ({ position }) => position.end.line - position.start.line + 1;

const over = (max) => (item) => lines(first(item)) > max;

const hit = (max) => (item) => ({
  line: first(item).position.start.line,
  actual: lines(first(item)),
  max,
});

export const check = (text, { max }) =>
  bullets(remark().parse(text).children).filter(over(max)).map(hit(max));
