import { remark } from "remark";
import { code, link, section } from "../elements.js";
import { fenced } from "../fences.js";

const defaults = [
  "error",
  { max: 80, [code]: { width: "off" }, [link]: { width: "off" } },
];

const measure = (shape) => (line, index) => ({
  line: index + 1,
  length: [...shape(line)].length,
});

const url = /\s*https?:\/\/\S+/g;

const shape = {
  true: (line) => line.replace(url, ""),
  false: (line) => line,
};

const off = ({ width }) => width === "off";

const numbered = (text, { [link]: web }) =>
  text.split("\n").map(measure(shape[off(web)]));

const skip = (text, { [code]: fence }) =>
  [fence].filter(off).flatMap(() => fenced(text));

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
  undefined: (name, value, self) => self,
  string: (name) => ({ id: name, max: Infinity }),
  object: (name, [severity, { max }]) => ({ id: name, severity, max }),
};

const own = (kind, settings, self) => {
  const name = [`${kind}.${section}.width`, key].find((k) => k in settings);
  return limits[typeof settings[name]](name, settings[name], self);
};

const self = (kind, max) => ({ id: `${kind}.width`, max });

const kept = (text, config) =>
  numbered(text, config).filter(prose(skip(text, config)));

const outside = (text, config, owner) =>
  band(kept(text, config), before(opening(text)), owner);

const within = (text, config, owner) =>
  band(kept(text, config), inside(opening(text)), owner);

const check =
  (kind) =>
  (text, { max, ...config }, settings) => [
    ...outside(text, config, self(kind, max)),
    ...within(text, config, own(kind, settings, self(kind, max))),
  ];

export const rule = (kind) => ({
  id: `${kind}.width`,
  defaults,
  check: check(kind),
});
