import { remark } from "remark";
import { code, link, section } from "../elements.js";
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

const off = (name) => ({ id: name, max: Infinity });

const limits = {
  undefined: (name, value, fallback) => fallback,
  string: (name) => off(name),
  object: (name, [severity, { max }]) => ({ id: name, severity, max }),
};

const width = (name, settings, fallback) =>
  limits[typeof settings[name]](name, settings[name], fallback);

const sectionkey = (kind, settings) =>
  [`${kind}.${section}.width`, `${section}.width`].find((k) => k in settings);

const own = (kind, settings, fallback) =>
  width(sectionkey(kind, settings), settings, fallback);

const self = (kind, max) => ({ id: `${kind}.width`, max });

const codeid = `${code}.width`;

const linkid = `${link}.width`;

const on = (settings) => width(linkid, settings, off(linkid)).max !== Infinity;

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

const tier = (kind, max, text, settings) => [
  ...band(self(kind, max))(outside(text, settings)),
  ...band(own(kind, settings, self(kind, max)))(within(text, settings)),
];

const mark = (text, settings) => [
  ...band(width(codeid, settings, off(codeid)))(codes(text).map(whole)),
  ...band(width(linkid, settings, off(linkid)))(links(text).map(whole)),
];

const hits = (kind, max, text, settings) =>
  [...tier(kind, max, text, settings), ...mark(text, settings)].sort(byline);

export const rule = (kind) => ({
  id: `${kind}.width`,
  defaults,
  check: (text, { max }, settings) => hits(kind, max, text, settings),
});
