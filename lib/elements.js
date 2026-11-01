export const skill = "skill";
export const agent = "agent";
export const section = "section";
export const step = "step";
export const code = "code";
export const link = "link";

const patterns = [
  [/(^|\/)SKILL\.md$/, skill],
  [/(^|\/)agents\/[^/]+\.md$/, agent],
];

export const kind = (file) =>
  patterns.filter(([re]) => re.test(file)).map(([, name]) => name)[0];
