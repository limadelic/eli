Feature: Lines

  Scenario: a long skill fails
    * > touch long/SKILL.md
      """
      # Long

      - one
      - two
      - three
      - four
      - five
      - six
      - seven
      - eight
      """
    * > eli long
      | long/SKILL.md:10 lines 10 > 9 |

  Scenario: a short skill passes
    * > touch short/SKILL.md
      """
      # Short

      - one
      """
    * > eli short
