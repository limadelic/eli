Feature: section

  Rule: width

    Scenario: a section's own width beats the inherited one
      * > touch .eli.yml
        """
        section:
          width: 100
        """
      * > touch wide/SKILL.md
        """
        # Wide

        abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghij

        ## Part

        Short.
        Ok.
        abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghij
        """
      * > run wide
      * the exit code is 1
      * the output is exactly
        | wide/SKILL.md:3 skill.width 90 > 80 |

    Scenario: a section line over its own width warns as section.width
      * > touch .eli.yml
        """
        section:
          width: [warn, 50]
        """
      * > touch wide/SKILL.md
        """
        # Wide

        Short intro.

        ## Part

        Short.
        Ok.
        abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghij
        """
      * > run wide
      * the exit code is 0
      * the output is exactly
        | wide/SKILL.md:9 section.width 60 > 50 |
