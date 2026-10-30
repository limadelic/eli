export const limit = (limits, word) =>
  Number(limits.match(new RegExp(`max (\\d+) ${word}`))[1]);
