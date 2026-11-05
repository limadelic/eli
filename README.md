# eli

<!-- badges-start -->

[![cukes](https://img.shields.io/endpoint?url=https%3A%2F%2Flimadelic.github.io%2Feli%2Fmain%2Fcukes%2Fbadge.json&cacheSeconds=60)](https://limadelic.github.io/eli/main/cukes/report.html)

<!-- badges-end -->

The md linter for Claude skills and elita agents.

## Config

eli lints the files you pass. A dir is searched recursively. `SKILL.md` is a skill. A `.md` file directly in an `agents` dir is an agent, for example `.claude/agents/x.md`. Other `.md` files are skipped.

Config is a `.eli.yml` file with four keys:

```yaml
sections: 7
steps: 7
step: 255
bullet: "-"
```

| Key        | Counts                                                         | Default |
| ---------- | -------------------------------------------------------------- | ------- |
| `sections` | `##` sections in a file                                        | 7       |
| `steps`    | top-level items in a section, bullets and paragraphs alike     | 7       |
| `step`     | characters in one top-level item, a link counts its label only | 255     |
| `bullet`   | the list marker, `-`, `*` or `+`                               | `"-"`   |

Each numeric key takes a number N. A count over N is a finding at N. `bullet` takes one marker, `"-"`, `"*"` or `"+"`, and a bullet with another marker is a finding. Any other value is invalid.

Lookup: the first value set wins per key. The order is `--config <file>`, then each `.eli.yml` from the current dir up to the root, nearest first, then `~/.claude/skills/.eli.yml`, then the defaults.

Output is `<path>:<line> <id> <actual> > <max>`:

```
wide/SKILL.md:21 sections 8 > 7
wide/SKILL.md:13 steps 8 > 7
```

Frontmatter is checked on every file. `name` is required, max 64 characters. `description` is required, max 1024 characters. A missing field is a finding, as `<path>:1 name missing`. Config cannot set or turn these off.

Exit codes:

- `0`: clean
- `1`: a finding
- `2`: an unknown key (for example `width` or `skill`) or an invalid value (for example `[warn, 2]`). With an invalid value, eli checks no files.
