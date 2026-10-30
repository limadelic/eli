Feature: Sections

  Scenario: a wide skill fails
    * > touch wide/SKILL.md
      """
      # Wide

      ## a

      ## b

      ## c
      """
    * > eli wide
      | wide/SKILL.md:7 sections 3 > 2 |

  Scenario: a narrow skill passes
    * > touch narrow/SKILL.md
      """
      # Narrow

      ## a

      ### b

      ## c
      """
    * > eli narrow
