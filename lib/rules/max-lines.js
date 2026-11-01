export const id = "max-lines";

export const defaults = ["error", { max: 250 }];

const count = (text) => text.split("\n").length - 1;

export const check = (text, { max }) =>
  [count(text)]
    .filter((n) => n > max)
    .map((n) => ({ line: n, message: `lines ${n} > ${max} ${id}` }));
