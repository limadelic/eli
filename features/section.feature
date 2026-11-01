Feature: section

  Rule: width

    Scenario: section width beats the skill and the nested one beats both
      * > touch .eli.yml
        """
        skill:
          width: 60
          section:
            width: 100
        section:
          width: 70
        """
      * > touch wide/SKILL.md
        """
        # Wide

        abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcde

        ## Part

        abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghij

        abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghija

        Short.
        Ok.
        """
      * > run wide
      * the exit code is 1
      * the output is exactly
        | wide/SKILL.md:3 skill.width 65 > 60 |
        | wide/SKILL.md:9 skill.section.width 101 > 100 |

    Scenario: severity per element
      * > touch .eli.yml
        """
        skill:
          width: [warn, 80]
        section:
          width: off
        """
      * > touch wide/SKILL.md
        """
        # Wide

        abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcde

        ## Part

        abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghij
        """
      * > run wide
      * the exit code is 0
      * the output is exactly
        | wide/SKILL.md:3 skill.width 85 > 80 |
