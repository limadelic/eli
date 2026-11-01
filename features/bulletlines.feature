Feature: Bullet lines

  Background:
    * > touch .eli.yml
      """
      max-bullet-lines:
        - error
        - max: 2
      """

  Scenario: a short bullet passes
    * > touch short/SKILL.md
      """
      # Short

      ## a

      - one two
        three
      """
    * > eli short
