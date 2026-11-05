import * as sections from "./sections.js";
import * as steps from "./steps.js";
import * as step from "./step.chars.js";
import * as bullet from "./bullet.js";

export const rules = {
  sections: { value: 7, check: sections.check },
  steps: { value: 7, check: steps.check },
  step: { value: 255, check: step.check },
  bullet: { value: "-", check: bullet.check },
};
