const marks = ["-", "*", "+"];

const severities = ["warn", "error"];

const type = (value) => Object.prototype.toString.call(value);

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

const marked = (value) => marks.includes(value);

const numbered = (value) => valids[type(value)](value);

const byid = { true: marked, false: numbered };

export const valid = (id, value) => byid[id === "bullet"](value);

const fallback = (value) => ["error", value];

const shape = { true: (value) => value, false: fallback };

export const level = (value) => shape[Array.isArray(value)](value);
