Feature: Len

  Background:
    * > touch .eli.yml
      """
      max-len:
        - error
        - max: 20
      """

  Scenario: a short skill passes
    * > touch short/SKILL.md
      """
      abcdefghijklmnopqrst
      """
    * > eli short
