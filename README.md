# eli

<!-- badges-start -->

[![cukes](https://img.shields.io/endpoint?url=https%3A%2F%2Flimadelic.github.io%2Feli%2Fmain%2Fcukes%2Fbadge.json&cacheSeconds=60)](https://limadelic.github.io/eli/main/cukes/report.html)

<!-- badges-end -->

The md linter for Claude skills and elita agents.

## Config

eli lints the files you pass. `SKILL.md` is a skill. A `.md` in an `agents` dir is an agent. Other `.md` files are skipped. Args are files or dirs.

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

| Selector  | Prop       | Counts                                             | Default     |
| --------- | ---------- | -------------------------------------------------- | ----------- |
| `skill`   | `lines`    | lines in the file                                  | 250         |
| `skill`   | `sections` | `##` sections                                      | 7           |
| `skill`   | `width`    | characters per prose line before the first section | 80          |
| `section` | `width`    | characters per prose line inside a section         | skill width |
| `section` | `steps`    | top-level bullets in a section                     | 7           |
| `step`    | `lines`    | lines in one step                                  | 2           |
| `code`    | `width`    | characters in fenced code lines                    | off         |
| `link`    | `width`    | characters in a URL                                | off         |

`agent` takes the same props as `skill`. `code` and `link` default to `off`, which skips fenced code and does not count URLs.

Values:

- `N`: error at N
- `[warn, N]`: warning at N
- `[error, N]`: error at N
- `off`: rule skipped

Lookup:

- A nested selector beats a global one. `skill.section.width` beats `section.width`.
- Per prop, the first source that sets it wins: `--config <file>`, then each `.eli.yml` from the current dir up to the root, nearest first, then `~/.claude/skills/.eli.yml`, then the defaults.

Output is `<path>:<line> <id> <actual> > <max>`. A warning has `warn ` before the id:

```
wide/SKILL.md:9 warn section.width 71 > 70
```

Exit codes:

- `0`: no errors, warnings only or clean
- `1`: at least one error
- `2`: bad config, an unknown rule or an invalid value. With an invalid value, eli checks no files.
