import { remark } from "remark";

export const id = "max-sections";

export const defaults = ["error", { max: 7 }];

const headings = (text) =>
  remark()
    .parse(text)
    .children.filter((node) => node.depth === 2);

const report = (all, max) => (heading) => ({
  line: heading.position.start.line,
  message: `sections ${all.length} > ${max}`,
});

export const check = (text, { max }) => {
  const all = headings(text);
  return all.slice(max, max + 1).map(report(all, max));
};
