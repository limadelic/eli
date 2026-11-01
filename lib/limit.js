import { remark } from "remark";

const report = (name, all, max) => (item) => ({
  line: item.position.start.line,
  message: `${name} ${all.length} > ${max}`,
});

const check =
  (name, items) =>
  (text, { max }) => {
    const all = items(remark().parse(text));
    return all.slice(max, max + 1).map(report(name, all, max));
  };

export const limit = (name, items) => ({
  defaults: ["error", { max: 7 }],
  check: check(name, items),
});
