const list = (node) => node.type === "list";

export const bullets = (nodes) =>
  nodes.filter(list).flatMap((node) => node.children);
