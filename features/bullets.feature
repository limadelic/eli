Feature: Bullets

  Background:
    * > touch .eli.yml
      """
      max-bullets:
        - error
        - max: 2
      """

  Scenario: a short section passes
    * > touch short/SKILL.md
      """
      # Short

      ## a

      - one
      - two
      """
    * > eli short
