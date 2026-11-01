Feature: Config

  Scenario: a rule set to off is skipped
    * > touch .eli.yml
      """
      max-sections: off
      """
    * > touch wide/SKILL.md
      """
      # Wide

      ## a

      ## b

      ## c

      ## d

      ## e

      ## f

      ## g

      ## h
      """
    * > eli wide
