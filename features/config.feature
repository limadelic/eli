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

  Scenario: a project .eli.yml beats the home one
    * > touch .eli.yml
      """
      max-lines: [error, {max: 2}]
      """
    * > touch proj/.eli.yml
      """
      max-lines: [error, {max: 9}]
      """
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
    * > cd proj
    * > eli long
      | long/SKILL.md:10 max-lines 10 > 9 |

  Scenario: the --config flag beats project and home configs
    * > touch .eli.yml
      """
      max-lines: [error, {max: 2}]
      """
    * > touch proj/.eli.yml
      """
      max-lines: [error, {max: 2}]
      """
    * > touch flag.yml
      """
      max-lines: [error, {max: 9}]
      """
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
    * > cd proj
    * > eli --config ../flag.yml long
      | long/SKILL.md:10 max-lines 10 > 9 |

  Scenario: a nested skill width can warn
    * > touch .eli.yml
      """
      skill:
        width: [warn, 10]
      """
    * > touch short/SKILL.md
      """
      abcdefghijklm
      """
    * > eli short
      | short/SKILL.md:1 skill.width 13 > 10 |

  Scenario: a nested skill width can be off
    * > touch .eli.yml
      """
      skill:
        width: off
      """
    * > touch short/SKILL.md
      """
      abcdefghijklm
      """
    * > eli short
