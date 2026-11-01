import { limit } from "../limit.js";

export const rule = (kind) => ({
  id: `${kind}.sections`,
  ...limit((tree) => [tree.children.filter((node) => node.depth === 2)]),
});
