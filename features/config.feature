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

  Scenario: an unknown rule id is reported
    * > touch .eli.yml
      """
      max-foo:
        - error
      """
    * > touch short/SKILL.md
      """
      # Short
      """
    * > eli short
      | .eli.yml unknown rule max-foo |
