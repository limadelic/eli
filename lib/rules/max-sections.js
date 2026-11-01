import { limit } from "../limit.js";

export const id = "max-sections";

export const { defaults, check } = limit((tree) => [
  tree.children.filter((node) => node.depth === 2),
]);
