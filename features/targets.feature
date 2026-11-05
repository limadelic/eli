Feature: Targets

  Rule: which files are linted

    Scenario: an agent file in an agents dir is linted
      * > touch agents/x.md
        """
        ---
        description: Fixture.
        ---

        # X

        Ok.
        """
      * > run .
      * the exit code is 1
      * the output is exactly
        | agents/x.md:1 name missing |

    Scenario: an other md file is skipped
      * > touch notes/x.md
        """
        ---
        description: Fixture.
        ---

        # X

        Ok.
        """
      * > run .
      * the exit code is 0
      * the output is empty

    Scenario: an agent is linted and an other md file beside it is skipped
      * > touch agents/x.md
        """
        ---
        description: Fixture.
        ---

        # X

        Ok.
        """
      * > touch notes/x.md
        """
        ---
        description: Fixture.
        ---

        # X

        Ok.
        """
      * > run .
      * the exit code is 1
      * the output is exactly
        | agents/x.md:1 name missing |
