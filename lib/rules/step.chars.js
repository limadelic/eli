import { remark } from "remark";
import { groups } from "./steps.js";

const defaults = ["error", { max: 255 }];

const joined = ["listItem", "list", "blockquote", "table", "tableRow"];

const glue = ["", " "];

const sep = (node) => glue[Number(joined.includes(node.type))];

const kids = (node) => [].concat(node.children).filter(Boolean);

const value = (node) => [node.value, " "][Number(node.type === "break")];

const words = (node) =>
  [value(node), kids(node).map(words).join(sep(node))].join("");

const size = (node) => [...words(node).replace(/\s+/g, " ").trim()].length;

const over = (max) => (node) => size(node) > max;

const hit = (max) => (node) => ({
  line: node.position.start.line,
  actual: size(node),
  max,
});

export const top = {
  id: "step",
  defaults,
  check: (text, { max }) =>
    groups(remark().parse(text)).flat().filter(over(max)).map(hit(max)),
};
