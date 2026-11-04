import { limit } from "../limit.js";
import { bullets } from "../bullets.js";
import { sections } from "./section.steps.js";

const plain = (node) => node.type !== "list";

const line = (node) => node.position.start.line;

const steps = (nodes) =>
  [...nodes.filter(plain), ...bullets(nodes)].sort((a, b) => line(a) - line(b));

const body = (group) => group.slice(1);

export const top = {
  id: "steps",
  ...limit((tree) => sections(tree.children).slice(1).map(body).map(steps)),
};
