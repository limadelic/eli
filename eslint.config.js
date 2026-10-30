import stylistic from "@stylistic/eslint-plugin";

const shebang = (comment) => comment.type === "Shebang";

const report = (context) => (comment) =>
  context.report({ loc: comment.loc, message: "No comments in code." });

const check = (context) => () => {
  const comments = context.sourceCode.getAllComments();
  comments.filter((comment) => !shebang(comment)).forEach(report(context));
};

const nocomments = {
  meta: { type: "problem", schema: [] },
  create: (context) => ({ Program: check(context) }),
};

export default [
  { ignores: ["vendor/**", "reports/**"] },
  {
    files: ["**/*.js"],
    languageOptions: { ecmaVersion: "latest", sourceType: "module" },
    plugins: {
      "@stylistic": stylistic,
      local: { rules: { nocomments } },
    },
    linterOptions: { noInlineConfig: true },
    rules: {
      "max-lines-per-function": ["error", { max: 5 }],
      "max-lines": ["error", { max: 100 }],
      complexity: ["error", 1],
      "max-depth": ["error", 2],
      "max-params": ["error", 5],
      "@stylistic/max-len": ["error", 80],
      "id-match": ["error", "^[a-z]+$"],
      "local/nocomments": "error",
    },
  },
];
