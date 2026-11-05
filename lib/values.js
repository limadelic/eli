const marks = ["-", "*", "+"];

const number = (value) => typeof value === "number";

const marker = (value) => marks.includes(value);

const byid = { true: marker, false: number };

export const valid = (id, value) => byid[id === "bullet"](value);
