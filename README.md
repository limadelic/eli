# eli

<!-- badges-start -->

[![cukes](https://img.shields.io/endpoint?url=https%3A%2F%2Flimadelic.github.io%2Feli%2Fmain%2Fcukes%2Fbadge.json&cacheSeconds=60)](https://limadelic.github.io/eli/main/cukes/report.html)

<!-- badges-end -->

The md linter for Claude skills and elita agents.

## Config

eli lints the files you pass. A dir is searched recursively. `SKILL.md` is a skill. A `.md` file directly in an `agents` dir is an agent, for example `.claude/agents/x.md`. Other `.md` files are skipped.

Config is a `.eli.yml` file in CSS-like shape. Elements are `skill`, `agent`, `section`, `step`, `code` and `link`. Props are `lines`, `width`, `sections` and `steps`. A nested selector targets one element inside another.

```yaml
skill:
  lines: 300
  sections: 7
  width: 80
  section:
    width: 100
agent:
  width: [warn, 60]
section:
  steps: 7
step:
  lines: 2
code:
  width: 120
link:
  width: 200
```

| Selector  | Prop       | Counts                                                               | Default              |
| --------- | ---------- | -------------------------------------------------------------------- | -------------------- |
| `skill`   | `lines`    | lines in the file                                                    | 250                  |
| `skill`   | `sections` | `##` sections                                                        | 7                    |
| `skill`   | `width`    | characters per prose line before the first section                   | 80                   |
| `section` | `width`    | characters per prose line inside a section                           | skill or agent width |
| `section` | `steps`    | top-level list items in a section; pre-`##` text is one section      | 7                    |
| `step`    | `lines`    | lines in one step (a list item), without nested lists or blank lines | 2                    |
| `code`    | `width`    | characters in fenced code lines                                      | off                  |
| `link`    | `width`    | characters in a URL, not the link label                              | off                  |

`agent` takes the same props as `skill`. `skill` props do not apply to agents.

`code` and `link` default to `off` and do not inherit the file width. `off` skips the check.

`link` is an inline element. It measures the URL text only. Prose around a URL is measured against the width that applies to its line, with the URL taken out.

Values:

- `N`: error at N
- `[warn, N]`: warning at N
- `[error, N]`: error at N
- `off`: rule skipped

Lookup:

- A child's own value beats an inherited one. `off` is a value like any other. So `skill: {width: off}` with `code: {width: 80}` still checks code lines at 80.
- A section line's width is the first one set of `skill.section.width`, `section.width`, `skill.width`, then the default (80).
- For agents, `agent` replaces `skill` in those keys: `agent.section.width`, `section.width`, `agent.width`, then 80.
- Per prop, the first source that sets it wins: `--config <file>`, then each `.eli.yml` from the current dir up to the root, nearest first, then `~/.claude/skills/.eli.yml`, then the defaults.

Output is `<path>:<line> <id> <actual> > <max>`. A warning has `warn ` before the id:

```
wide/SKILL.md:9 warn section.width 71 > 70
```

Exit codes:

- `0`: no errors, warnings only or clean
- `1`: at least one error
- `2`: an unknown rule or an invalid value. With an invalid value, eli checks no files.
