import { remark } from "remark";

export const id = "max-bullet-lines";

export const defaults = ["error", { max: 2 }];

const list = (node) => node.type === "list";

const bullets = (tree) =>
  tree.children.filter(list).flatMap((node) => node.children);

const own = (item) => [item.children[0], item].find(Boolean);

const lines = ({ position }) => position.end.line - position.start.line + 1;

const over = (max) => (item) => lines(own(item)) > max;

const hit = (max) => (item) => ({
  line: own(item).position.start.line,
  message: `lines ${lines(own(item))} > ${max}`,
});

export const check = (text, { max }) =>
  bullets(remark().parse(text)).filter(over(max)).map(hit(max));
