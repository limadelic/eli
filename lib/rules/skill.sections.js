import { skill } from "../elements.js";
import { limit } from "../limit.js";

export const id = `${skill}.sections`;

export const { defaults, check } = limit((tree) => [
  tree.children.filter((node) => node.depth === 2),
]);
