import { bullet } from "./elements.js";

const type = (value) => Object.prototype.toString.call(value);

const marks = ["-", "*", "+"];

const shapes = {
  "[object Number]": (max) => ["error", { max }],
  "[object Array]": ([severity, max]) => [severity, { max }],
  "[object String]": (off) => off,
  "[object Boolean]": (value) => value,
  "[object Null]": (value) => value,
};

const shaping = {
  true: (value) => ["error", { max: value }],
  false: (value) => shapes[type(value)](value),
};

const shape = (id, value) => shaping[id === bullet](value);

export const shaped = (settings) =>
  Object.fromEntries(
    Object.entries(settings).map(([id, value]) => [id, shape(id, value)]),
  );

const severities = ["warn", "error"];

const checks = [
  ([severity]) => severities.includes(severity),
  ([, max]) => typeof max === "number",
  (value) => value.length === 2,
];

const pair = (value) => checks.every((check) => check(value));

const valids = {
  "[object Number]": () => true,
  "[object String]": (value) => value === "off",
  "[object Array]": pair,
  "[object Boolean]": () => false,
  "[object Null]": () => false,
};

const validity = {
  true: (value) => marks.includes(value),
  false: (value) => valids[type(value)](value),
};

export const valid = (id, value) => validity[id === bullet](value);
