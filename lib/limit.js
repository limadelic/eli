import { remark } from "remark";

const report = (max, all) => (item) => ({
  line: item.position.start.line,
  actual: all.length,
  max,
});

export const limit = (groups) => (text, max) =>
  groups(remark().parse(text)).flatMap((all) =>
    all.slice(max, max + 1).map(report(max, all)),
  );
