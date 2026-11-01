import { remark } from "remark";

const report = (name, all, max) => (item) => ({
  line: item.position.start.line,
  message: `${name} ${all.length} > ${max}`,
});

const check =
  (name, groups) =>
  (text, { max }) =>
    groups(remark().parse(text)).flatMap((all) =>
      all.slice(max, max + 1).map(report(name, all, max)),
    );

export const limit = (name, groups) => ({
  defaults: ["error", { max: 7 }],
  check: check(name, groups),
});
