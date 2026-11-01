Feature: skill

  Rule: width

    Scenario: over-width prose fails, code and links pass
      * > touch wide/SKILL.md
        """
        # Wide

        Short.
        Ok.

        ```
        abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghi
        ```

        See [the long docs](https://example.com/abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz).

        Read the full migration guide before you touch any file in the repo, it lists every step you need, see https://example.com/abc

        abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabc
        """
      * > run wide
      * the exit code is 1
      * the output is exactly
        | wide/SKILL.md:12 skill.width 102 > 80 |
        | wide/SKILL.md:14 skill.width 81 > 80 |

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

  Rule: sections

    Scenario: a skill over its sections fails, deeper headings do not count
      * > touch .eli.yml
        """
        skill:
          sections: 2
        """
      * > touch wide/SKILL.md
        """
        # Wide

        ## a

        ### a1

        ### a2

        ## b

        ### b1

        ## c
        """
      * > run wide
      * the exit code is 1
      * the output is exactly
        | wide/SKILL.md:13 skill.sections 3 > 2 |
