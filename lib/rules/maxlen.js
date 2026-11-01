import { remark } from "remark";

export const id = "max-len";

export const defaults = ["error", { max: 80 }];

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

const code = (node) => node.type === "code";

const span = ({ position }) =>
  [...Array(position.end.line - position.start.line + 1).keys()].map(
    (index) => position.start.line + index,
  );

const fenced = (text) => walk(remark().parse(text)).filter(code).flatMap(span);

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
  ({ line, length }) => ({
    line,
    message: `len ${length} > ${max}`,
  });

export const check = (text, { max }) =>
  numbered(text)
    .filter(prose(fenced(text)))
    .filter(over(max))
    .map(hit(max));
