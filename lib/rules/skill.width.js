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

const band = (lines, keep, owner) =>
  lines
    .filter(keep)
    .filter(over(owner.max))
    .map(({ line, length }) => ({ actual: length, line, ...owner }));

const key = `${section}.width`;

const limits = {
  undefined: (value, max) => ({ id, max }),
  string: () => ({ id: key, max: Infinity }),
  object: ([severity, { max }]) => ({ id: key, severity, max }),
};

const own = (settings, max) => limits[typeof settings[key]](settings[key], max);

const kept = (text, config) => numbered(text).filter(prose(skip(text, config)));

export const check = (text, { max, ...config }, settings) => [
  ...band(kept(text, config), before(opening(text)), { id, max }),
  ...band(kept(text, config), inside(opening(text)), own(settings, max)),
];
