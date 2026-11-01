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

  Scenario: a long bullet fails
    * > touch long/SKILL.md
      """
      # Long

      ## a

      - one
        two
        three
      """
    * > eli long
      | long/SKILL.md:5 max-bullet-lines 3 > 2 |

  Scenario: nested bullets do not count
    * > touch nested/SKILL.md
      """
      # Nested

      ## a

      - one
        - two
        - three
      """
    * > eli nested
