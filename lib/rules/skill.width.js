import { remark } from "remark";
import { skill, code } from "../elements.js";

export const id = `${skill}.width`;

export const defaults = ["error", { max: 80, [code]: { width: "off" } }];

const measure = (line, index) => ({
  line: index + 1,
  text: line,
  length: [...line].length,
});

const bare = ({ text }) => !/^https?:\/\/\S+$/.test(text);

const numbered = (text) => text.split("\n").map(measure).filter(bare);

const walk = (node) => [
  node,
  ...Object.values(node).filter(Array.isArray).flat().flatMap(walk),
];

const block = (node) => node.type === "code";

const span = ({ position }) =>
  [...Array(position.end.line - position.start.line + 1).keys()].map(
    (index) => position.start.line + index,
  );

const fenced = (text) => walk(remark().parse(text)).filter(block).flatMap(span);

const off = ({ width }) => width === "off";

const skip = (text, child) => [child].filter(off).flatMap(() => fenced(text));

const prose =
  (lines) =>
  ({ line }) =>
    !lines.includes(line);

const over =
  (max) =>
  ({ length }) =>
    length > max;

const hit =
  (max) =>
  ({ line, length }) => ({ line, actual: length, max });

export const check = (text, { max, [code]: child }) =>
  numbered(text)
    .filter(prose(skip(text, child)))
    .filter(over(max))
    .map(hit(max));
