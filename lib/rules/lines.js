const count = (text) => text.split("\n").length - 1;

const check = (text, { max }) =>
  [count(text)]
    .filter((n) => n > max)
    .map((n) => ({ line: n, actual: n, max }));

export const rule = (kind) => ({
  id: `${kind}.lines`,
  defaults: ["error", { max: 250 }],
  check,
});
