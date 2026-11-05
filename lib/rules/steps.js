import { limit } from "../limit.js";
import { bullets } from "../bullets.js";

const heading = (node) => node.depth === 2;

const headings = (children) =>
  [...children.keys()].filter((index) => heading(children[index]));

const sections = (children) => {
  const starts = [0, ...headings(children)];
  return starts.map((start, index) => children.slice(start, starts[index + 1]));
};

const plain = (node) => node.type !== "list";

const line = (node) => node.position.start.line;

const steps = (nodes) =>
  [...nodes.filter(plain), ...bullets(nodes)].sort((a, b) => line(a) - line(b));

const body = (group) => group.slice(1);

export const groups = (tree) =>
  sections(tree.children).slice(1).map(body).map(steps);

export const check = limit(groups);
