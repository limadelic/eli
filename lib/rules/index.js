import { agent, section, skill } from "../elements.js";
import * as lines from "./lines.js";
import * as sections from "./sections.js";
import * as width from "./width.js";
import * as steps from "./section.steps.js";
import * as steplines from "./step.lines.js";

const scoped = [lines, sections, width];

export const kinds = [skill, agent];

const stepskey = (kind, settings) =>
  [`${kind}.section.steps`, "section.steps"]
    .filter((id) => id in settings)
    .concat("section.steps")[0];

export const rules = (kind, settings) => [
  ...scoped.map((mod) => mod.rule(kind)),
  steps.rule(stepskey(kind, settings)),
  steplines,
];

export const known = [
  ...kinds.flatMap((kind) => [
    `${kind}.${section}.width`,
    `${kind}.${section}.steps`,
  ]),
  ...kinds.flatMap((kind) => rules(kind, {}).map((rule) => rule.id)),
  `${section}.width`,
  ...kinds,
];
