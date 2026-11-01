import { limit } from "../limit.js";
import { bullets } from "../bullets.js";

export const id = "max-bullets";

const heading = (node) => node.depth === 2;

const headings = (children) =>
  [...children.keys()].filter((index) => heading(children[index]));

const sections = (children) => {
  const starts = [0, ...headings(children)];
  return starts.map((start, index) => children.slice(start, starts[index + 1]));
};

export const { defaults, check } = limit("bullets", (tree) =>
  sections(tree.children).map(bullets),
);
