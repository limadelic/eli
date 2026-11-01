import { remark } from "remark";
import { code, link, section } from "../elements.js";
import { cascade, off } from "../cascade.js";
import { fenced } from "../fences.js";

const defaults = ["error", { max: 80 }];

const url = /\s*https?:\/\/\S+/g;

const linked = (raw) => /https?:\/\//.test(raw);

const size = (raw) => [...raw].length;

const lined = (text) =>
  text.split("\n").map((raw, index) => ({ line: index + 1, raw }));

const plain = ({ line, raw }) => ({ line, length: size(raw.replace(url, "")) });

const whole = ({ line, raw }) => ({ line, length: size(raw) });

const hidden = { true: linked, false: () => false };

const infence = (fence) => (item) => fence.includes(item.line);

const notfence = (fence) => (item) => !fence.includes(item.line);

const base = { severity: defaults[0], max: defaults[1].max };

const self = (kind) => ({ id: `${kind}.width`, ...base });

const sectionkeys = (kind) => [
  `${kind}.${section}.width`,
  `${section}.width`,
  `${kind}.width`,
];

const topwidth = (kind, settings) =>
  cascade([`${kind}.width`], settings, self(kind));

const sectionwidth = (kind, settings) =>
  cascade(sectionkeys(kind), settings, self(kind));

const codeid = `${code}.width`;
const linkid = `${link}.width`;

const codewidth = (settings) => cascade([codeid], settings, off(codeid));

const linkwidth = (settings) => cascade([linkid], settings, off(linkid));

const on = (settings) => linkwidth(settings).max !== Infinity;

const body = (text) => lined(text).filter(notfence(fenced(text)));

const unhidden = (settings) => (item) => !hidden[on(settings)](item.raw);

const prose = (text, settings) =>
  body(text).filter(unhidden(settings)).map(plain);

const codes = (text) => lined(text).filter(infence(fenced(text)));

const links = (text) => body(text).filter((item) => linked(item.raw));

const subhead = (node) => node.depth === 2;

const start = ({ position }) => position.start.line;

const opening = (text) =>
  Math.min(...remark().parse(text).children.filter(subhead).map(start));

const outside = (text, settings) =>
  prose(text, settings).filter((item) => item.line < opening(text));

const within = (text, settings) =>
  prose(text, settings).filter((item) => item.line >= opening(text));

const band = (owner) => (items) =>
  items
    .filter(({ length }) => length > owner.max)
    .map(({ line, length }) => ({ actual: length, line, ...owner }));

const byline = (a, b) => a.line - b.line;

const tier = (kind, text, settings) => [
  ...band(topwidth(kind, settings))(outside(text, settings)),
  ...band(sectionwidth(kind, settings))(within(text, settings)),
];

const mark = (text, settings) => [
  ...band(codewidth(settings))(codes(text).map(whole)),
  ...band(linkwidth(settings))(links(text).map(whole)),
];

const hits = (kind, text, settings) =>
  [...tier(kind, text, settings), ...mark(text, settings)].sort(byline);

export const rule = (kind) => ({
  id: `${kind}.width`,
  defaults,
  check: (text, options, settings) => hits(kind, text, settings),
});
