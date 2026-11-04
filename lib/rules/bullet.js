import { remark } from "remark";
import { bullet } from "../elements.js";
import { groups } from "./steps.js";

const defaults = ["error", { max: "-" }];

const marker = /^(\d+[.)]|[-*+])/;

const mark = (text) => (item) =>
  text.slice(item.position.start.offset).match(marker)[0];

const items = (tree) =>
  groups(tree)
    .flat()
    .filter((node) => node.type === "listItem");

const hit = (text, max) => (item) => ({
  line: item.position.start.line,
  actual: mark(text)(item),
  max,
});

export const top = {
  id: bullet,
  defaults,
  check: (text, { max }) =>
    items(remark().parse(text))
      .map(hit(text, max))
      .filter(({ actual }) => actual !== max),
};
