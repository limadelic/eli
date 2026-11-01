const type = (value) => Object.prototype.toString.call(value);

const shapes = {
  "[object Number]": (max) => ["error", { max }],
  "[object Array]": ([severity, max]) => [severity, { max }],
  "[object String]": (off) => off,
  "[object Boolean]": (value) => value,
  "[object Null]": (value) => value,
};

const shape = (value) => shapes[type(value)](value);

export const shaped = (settings) =>
  Object.fromEntries(
    Object.entries(settings).map(([id, value]) => [id, shape(value)]),
  );

const severities = ["warn", "error"];

const pair = ([severity, max]) =>
  [severities.includes(severity), typeof max === "number"].every(Boolean);

const valids = {
  "[object Number]": () => true,
  "[object String]": (value) => value === "off",
  "[object Array]": pair,
  "[object Boolean]": () => false,
  "[object Null]": () => false,
};

export const valid = (value) => valids[type(value)](value);
