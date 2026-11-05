Feature: Frontmatter

  Rule: name and description

    Scenario: a long name fails
      * > touch .eli.yml
        """
        """
      * > touch wide/SKILL.md
        """
        ---
        name: nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn
        description: Fixture.
        ---

        # Wide

        Ok.
        """
      * > run wide
      * the exit code is 1
      * the output is exactly
        | wide/SKILL.md:2 name 71 > 64 |

    Scenario: a long description fails
      * > touch .eli.yml
        """
        """
      * > touch wide/SKILL.md
        """
        ---
        name: wide
        description: dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
        ---

        # Wide

        Ok.
        """
      * > run wide
      * the exit code is 1
      * the output is exactly
        | wide/SKILL.md:3 description 1100 > 1024 |

    Scenario: a missing name fails
      * > touch .eli.yml
        """
        """
      * > touch wide/SKILL.md
        """
        ---
        description: Fixture.
        ---

        # Wide

        Ok.
        """
      * > run wide
      * the exit code is 1
      * the output is exactly
        | wide/SKILL.md:1 name missing |

    Scenario: a missing description fails
      * > touch .eli.yml
        """
        """
      * > touch wide/SKILL.md
        """
        ---
        name: wide
        ---

        # Wide

        Ok.
        """
      * > run wide
      * the exit code is 1
      * the output is exactly
        | wide/SKILL.md:1 description missing |
