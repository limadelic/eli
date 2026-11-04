import { limit } from "../limit.js";

const headings = limit((tree) => [
  tree.children.filter((node) => node.depth === 2),
]);

export const rule = (kind) => ({
  id: `${kind}.sections`,
  ...headings,
});

export const top = {
  id: "sections",
  ...headings,
};
