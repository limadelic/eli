Feature: Bullets

  Background:
    * > touch .eli.yml
      """
      max-bullets:
        - error
        - max: 2
      """

  Scenario: a short skill passes
    * > touch short/SKILL.md
      """
      # Short

      ## a

      - one
      - two
      """
    * > eli short

  Scenario: a long skill fails
    * > touch long/SKILL.md
      """
      # Long

      ## a

      - one
      - two
      - three
      """
    * > eli long
      | long/SKILL.md:7 bullets 3 > 2 max-bullets |

  Scenario: bullets count per section
    * > touch sections/SKILL.md
      """
      # Sections

      ## a

      - one
      - two

      ## b

      - three
      - four
      """
    * > eli sections

  Scenario: nested bullets do not count
    * > touch nested/SKILL.md
      """
      # Nested

      ## a

      - one
        - one a
        - one b
      - two
      """
    * > eli nested
