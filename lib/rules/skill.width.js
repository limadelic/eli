import { remark } from "remark";
import { skill, code, link } from "../elements.js";

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

const skip = (text, { [code]: fence, [link]: web }) => [
  ...[fence].filter(off).flatMap(() => fenced(text)),
  ...[web].filter(off).flatMap(() => links(text)),
];

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

export const check = (text, { max, ...config }) =>
  numbered(text)
    .filter(prose(skip(text, config)))
    .filter(over(max))
    .map(hit(max));
