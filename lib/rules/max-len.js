export const id = "max-len";

export const defaults = ["error", { max: 80 }];

const measure = (line, index) => ({
  line: index + 1,
  length: [...line].length,
});

const numbered = (text) => text.split("\n").map(measure);

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
  numbered(text).filter(over(max)).map(hit(max));
