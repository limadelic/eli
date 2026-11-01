import { remark } from "remark";
import { skill, section, code, link } from "../elements.js";

export const id = `${skill}.width`;

export const defaults = [
  "error",
  { max: 80, [code]: { width: "off" }, [link]: { width: "off" } },
];

const measure = (line, index) => ({
  line: index + 1,
  text: line,
  length: [...line].length,
});

const numbered = (text) => text.split("\n").map(measure);

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

const url = /https?:\/\/\S+/;

const linked = ({ text }) => url.test(text);

const links = (text) =>
  numbered(text)
    .filter(linked)
    .map(({ line }) => line);

const off = ({ width }) => width === "off";

const gate = (text, value, find) =>
  [value].filter(off).flatMap(() => find(text));

const skip = (text, { [code]: fence, [link]: web }) => [
  ...gate(text, fence, fenced),
  ...gate(text, web, links),
];

const prose =
  (lines) =>
  ({ line }) =>
    !lines.includes(line);

const over =
  (max) =>
  ({ length }) =>
    length > max;

const subhead = (node) => node.depth === 2;

const start = ({ position }) => position.start.line;

const opening = (text) =>
  Math.min(...remark().parse(text).children.filter(subhead).map(start));

const before =
  (from) =>
  ({ line }) =>
    line < from;

const inside =
  (from) =>
  ({ line }) =>
    line >= from;

const hit =
  ({ id, max }) =>
  ({ line, length }) => ({ line, actual: length, max, id });

const sized = (settings) =>
  [settings[`${section}.width`]]
    .filter(Boolean)
    .map(([, { max }]) => ({ id: `${section}.width`, max }));

const intro = (lines, from, max) =>
  lines.filter(before(from)).filter(over(max)).map(hit({ id, max }));

const body = (lines, from, owner) =>
  lines.filter(inside(from)).filter(over(owner.max)).map(hit(owner));

const own = (settings, max) => [...sized(settings), { id, max }][0];

export const check = (text, { max, ...config }, settings) => {
  const from = opening(text);
  const lines = numbered(text).filter(prose(skip(text, config)));
  return [...intro(lines, from, max), ...body(lines, from, own(settings, max))];
};
