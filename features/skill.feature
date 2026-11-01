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
