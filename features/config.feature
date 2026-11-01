Feature: Config

  Scenario: a rule set to off is skipped
    * > touch .eli.yml
      """
      skill:
        sections: off
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

  Scenario: the nearest config wins per prop
    * > touch ../.eli.yml
      """
      """
    * > touch .eli.yml
      """
      skill:
        lines: 2
        sections: 1
        width: 10
      """
    * > touch proj/.eli.yml
      """
      skill:
        sections: 2
        width: 20
      """
    * > touch flag.yml
      """
      skill:
        width: 30
      """
    * > touch mix/SKILL.md
      """
      # Mix

      Lorem ipsum dolor sit amet, consectetur adipiscing.

      ## a

      ## b

      ## c
      """
    * > cd proj
    * > run --config ../flag.yml mix
    * the output is exactly
      | mix/SKILL.md:9 skill.lines 9 > 2 |
      | mix/SKILL.md:9 skill.sections 3 > 2 |
      | mix/SKILL.md:3 skill.width 51 > 30 |
    * the exit code is 1

  Scenario: off reports nothing
    * > touch .eli.yml
      """
      skill:
        width: off
      """
    * > touch wide/SKILL.md
      """
      # Wide

      Short.
      Ok.
      Fine.
      Done.
      abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabc
      """
    * > run wide
    * the exit code is 0
    * the output is empty
