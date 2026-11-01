Feature: section

  Rule: width

    Scenario: section width beats the skill width
      * > touch .eli.yml
        """
        skill:
          width: 60
        section:
          width: [warn, 70]
        """
      * > touch wide/SKILL.md
        """
        # Wide

        abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghij
        abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcde

        ## Part

        abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghij
        abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghija
        Short.
        """
      * > run wide
      * the exit code is 1
      * the output is exactly
        | wide/SKILL.md:4 skill.width 65 > 60 |
        | wide/SKILL.md:9 warn section.width 71 > 70 |

    Scenario: nested beats section
      * > touch .eli.yml
        """
        skill:
          section:
            width: 100
        section:
          width: 70
        """
      * > touch wide/SKILL.md
        """
        # Wide

        Short.

        ## Part

        abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghij
        abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghija
        """
      * > run wide
      * the exit code is 1
      * the output is exactly
        | wide/SKILL.md:8 skill.section.width 101 > 100 |

    Scenario: severity per element
      * > touch .eli.yml
        """
        skill:
          width: [warn, 60]
        section:
          width: off
        """
      * > touch wide/SKILL.md
        """
        # Wide

        abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcde

        ## Part

        abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghij
        """
      * > run wide
      * the exit code is 0
      * the output is exactly
        | wide/SKILL.md:3 warn skill.width 65 > 60 |
