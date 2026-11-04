Feature: skill

  Rule: width

    Scenario: over-width prose and code fail, links pass
      * > touch .eli.yml
        """
        code:
          width: 80
        link:
          width: 40
        """
      * > touch wide/SKILL.md
        """
        ---
        name: wide
        description: Fixture.
        ---
        # Wide

        Short.
        Ok.
        abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqr🎸🎸🎸🎸🎸🎸🎸🎸🎸🎸

        ```
        abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghi
        ```

        See [the long migration guide for every release and every step](https://example.com/abc).

        Read the full migration guide before you touch any file in the repo, it lists every step you need, see https://example.com/abc

        abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabc

        ## Part

        abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabc

        Mirror https://example.com/abcdefghijklmnopqrstuvwxyzabcd
        """
      * > run wide
      * the exit code is 1
      * the output is exactly
        | wide/SKILL.md:12 code.width 87 > 80 |
        | wide/SKILL.md:17 skill.width 102 > 80 |
        | wide/SKILL.md:19 skill.width 81 > 80 |
        | wide/SKILL.md:23 skill.width 81 > 80 |
        | wide/SKILL.md:25 link.width 50 > 40 |

  Rule: lines

    Scenario: a skill over its lines fails
      * > touch .eli.yml
        """
        skill:
          lines: 9
        """
      * > touch fit/SKILL.md
        """
        ---
        name: fit
        description: Fixture.
        ---
        # Fit

        Ok.
        Ok.
        Ok.
        """
      * > touch long/SKILL.md
        """
        ---
        name: long
        description: Fixture.
        ---
        # Long

        Ok.
        Ok.
        Ok.
        Ok.
        """
      * > eli fit
      * > run long
      * the exit code is 1
      * the output is exactly
        | long/SKILL.md:10 skill.lines 10 > 9 |

  Rule: sections

    Scenario: a skill over its sections fails, deeper headings do not count
      * > touch .eli.yml
        """
        skill:
          sections: 2
        """
      * > touch fit/SKILL.md
        """
        ---
        name: fit
        description: Fixture.
        ---
        # Fit

        ## a

        ### a1

        ## b
        """
      * > touch wide/SKILL.md
        """
        ---
        name: wide
        description: Fixture.
        ---
        # Wide

        ## a

        ### a1

        ### a2

        ## b

        ### b1

        ## c
        """
      * > eli fit
      * > run wide
      * the exit code is 1
      * the output is exactly
        | wide/SKILL.md:17 skill.sections 3 > 2 |
