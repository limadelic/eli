Feature: step

  Rule: lines

    Scenario: a step over its lines fails
      * > touch .eli.yml
        """
        step: {lines: 2}
        """
      * > touch steps/SKILL.md
        """
        # Steps

        ## a

        - one
          two

        - one
          two
          three

        - one
          - two
          - three

        - one

          two
          three
        """
      * > run steps
      * the exit code is 1
      * the output is exactly
        | steps/SKILL.md:8 step.lines 3 > 2 |
        | steps/SKILL.md:16 step.lines 3 > 2 |
