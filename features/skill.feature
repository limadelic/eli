Feature: skill

  Rule: width

    Scenario: a line over the width fails
      * > touch .eli.yml
        """
        skill:
          width: 10
        """
      * > touch wide/SKILL.md
        """
        # Wide

        ab🎸🎸🎸🎸🎸🎸🎸🎸
        Short.
        Ok.
        abcdefghijk
        """
      * > run wide
      * the exit code is 1
      * the output is exactly
        | wide/SKILL.md:6 skill.width 11 > 10 |

    Scenario: warn reports and exits 0
      * > touch .eli.yml
        """
        skill:
          width: [warn, 10]
        """
      * > touch wide/SKILL.md
        """
        # Wide

        Short.
        Ok.
        Fine.
        abcdefghijk
        """
      * > run wide
      * the exit code is 0
      * the output is exactly
        | wide/SKILL.md:6 skill.width 11 > 10 |

    Scenario: off reports nothing
      * > touch .eli.yml
        """
        skill:
          width: off
        """
      * > touch wide/SKILL.md
        """
        # Wide

        Short.
        Ok.
        Fine.
        Done.
        abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabc
        """
      * > run wide
      * the exit code is 0
      * the output is empty

    Scenario: a long line in a code fence passes
      * > touch wide/SKILL.md
        """
        # Wide

        Short.

        ```
        abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghi
        ```

        abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabc
        """
      * > run wide
      * the exit code is 1
      * the output is exactly
        | wide/SKILL.md:9 skill.width 81 > 80 |

    Scenario: a long link passes
      * > touch wide/SKILL.md
        """
        # Wide

        Short.
        See [the long docs](https://example.com/abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz).
        abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabc
        """
      * > run wide
      * the exit code is 1
      * the output is exactly
        | wide/SKILL.md:5 skill.width 81 > 80 |

    Scenario: a long line with a link still fails on its prose
      * > touch wide/SKILL.md
        """
        # Wide

        Short.
        Ok.
        Read the full migration guide before you touch any file in the repo, it lists every step you need, see https://example.com/abc
        """
      * > run wide
      * the exit code is 1
      * the output is exactly
        | wide/SKILL.md:5 skill.width 102 > 80 |

  Rule: lines

    Scenario: a skill over its lines fails
      * > touch .eli.yml
        """
        skill:
          lines: 5
        """
      * > touch long/SKILL.md
        """
        # Long

        Ok.
        Ok.
        Ok.
        Ok.
        """
      * > run long
      * the exit code is 1
      * the output is exactly
        | long/SKILL.md:6 skill.lines 6 > 5 |
