Feature: Frontmatter

  Rule: name and description

    Scenario: a long name and a long description fail
      * > touch .eli.yml
        """
        """
      * > touch wide/SKILL.md
        """
        ---
        name: nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn
        description: dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
        ---
        """
      * > run wide
      * the exit code is 1
      * the output is exactly
        | wide/SKILL.md:2 name 71 > 64 |
        | wide/SKILL.md:3 description 1100 > 1024 |

    Scenario: a file with no name and no description fails
      * > touch .eli.yml
        """
        """
      * > touch wide/SKILL.md
        """
        """
      * > run wide
      * the exit code is 1
      * the output is exactly
        | wide/SKILL.md:1 name missing |
        | wide/SKILL.md:1 description missing |
