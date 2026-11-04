import { limit } from "../limit.js";
import { bullets } from "../bullets.js";

const heading = (node) => node.depth === 2;

const headings = (children) =>
  [...children.keys()].filter((index) => heading(children[index]));

export const sections = (children) => {
  const starts = [0, ...headings(children)];
  return starts.map((start, index) => children.slice(start, starts[index + 1]));
};

export const rule = (id) => ({
  id,
  ...limit((tree) => sections(tree.children).map(bullets)),
});
