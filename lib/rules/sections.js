import { limit } from "../limit.js";

export const check = limit((tree) => [
  tree.children.filter((node) => node.depth === 2),
]);
