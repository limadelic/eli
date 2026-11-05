Feature: Targets

  Rule: which files are linted

    Scenario: an agent is linted and an other md file beside it is skipped
      * > touch .eli.yml
        """
        """
      * > touch agents/x.md
        """
        ---
        description: Fixture.
        ---
        """
      * > touch notes/x.md
        """
        """
      * > run .
      * the exit code is 1
      * the output is exactly
        | agents/x.md:1 name missing |
