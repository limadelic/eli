import { remark } from "remark";

const report = (max, all) => (item) => ({
  line: item.position.start.line,
  actual: all.length,
  max,
});

const check =
  (groups) =>
  (text, { max }) =>
    groups(remark().parse(text)).flatMap((all) =>
      all.slice(max, max + 1).map(report(max, all)),
    );

export const limit = (groups) => ({
  defaults: ["error", { max: 7 }],
  check: check(groups),
});
