import { remark } from "remark";
import { groups } from "./steps.js";

const pattern = /^(\d+[.)]|[-*+])/;

const mark = (text) => (item) =>
  text.slice(item.position.start.offset).match(pattern)[0];

const items = (tree) =>
  groups(tree)
    .flat()
    .filter((node) => node.type === "listItem");

const hit = (text, marker) => (item) => ({
  line: item.position.start.line,
  actual: mark(text)(item),
  max: marker,
});

export const check = (text, marker) =>
  items(remark().parse(text))
    .map(hit(text, marker))
    .filter(({ actual }) => actual !== marker);
