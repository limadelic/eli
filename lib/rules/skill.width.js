import { remark } from "remark";
import { skill, section, code, link } from "../elements.js";

export const id = `${skill}.width`;

export const defaults = [
  "error",
  { max: 80, [code]: { width: "off" }, [link]: { width: "off" } },
];

const measure = (shape) => (line, index) => ({
  line: index + 1,
  length: [...shape(line)].length,
});

const url = /https?:\/\/\S+/g;

const shape = {
  true: (line) => line.replace(url, ""),
  false: (line) => line,
};

const off = ({ width }) => width === "off";

const numbered = (text, { [link]: web }) =>
  text.split("\n").map(measure(shape[off(web)]));

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

const gate = (text, value, find) =>
  [value].filter(off).flatMap(() => find(text));

const skip = (text, { [code]: fence }) => gate(text, fence, fenced);

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

const kept = (text, config) =>
  numbered(text, config).filter(prose(skip(text, config)));

export const check = (text, { max, ...config }, settings) => [
  ...band(kept(text, config), before(opening(text)), { id, max }),
  ...band(kept(text, config), inside(opening(text)), own(settings, max)),
];
