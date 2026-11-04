import { parse } from "yaml";

const head = /^---\n([\s\S]*?)\n---(?=\n|$)/g;

const fields = [
  { id: "name", max: 64 },
  { id: "description", max: 1024 },
];

const size = (raw) => [...raw].length;

const bodies = (text) => [...text.matchAll(head)].map(([, body]) => body);

const read = (text) => Object.assign({}, parse(bodies(text).join("")));

const nullish = (raw) => ![undefined, null].includes(raw);

const value = (data, id) => String([data[id], ""].find(nullish)).trim();

const at = (text, id) => Math.max(0, text.search(new RegExp(`^${id}:`, "m")));

const line = (text, id) => text.slice(0, at(text, id)).split("\n").length;

const error = (id, line) => ({ line, id, severity: "error" });

const missing = (id) => ({ ...error(id, 1), actual: "missing" });

const long = (text, id, max, raw) => ({
  ...error(id, line(text, id)),
  actual: size(raw),
  max,
});

const absent = (raw) => raw === "";

const over = (max) => (raw) => size(raw) > max;

const hits = (text, id, max, raw) => [
  ...[raw].filter(absent).map(() => missing(id)),
  ...[raw].filter(over(max)).map(() => long(text, id, max, raw)),
];

export const frontmatter = (text) => {
  const data = read(text);
  return fields.flatMap(({ id, max }) => hits(text, id, max, value(data, id)));
};

export const blank = (text) =>
  text.replace(head, (block) => block.replace(/[^\n]/g, ""));
