import { limit } from "../limit.js";

export const id = "max-bullets";

export const { defaults, check } = limit("bullets", (tree) =>
  tree.children
    .filter((node) => node.type === "list")
    .flatMap((list) => list.children),
);
