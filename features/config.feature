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

  Scenario: a project .eli.yml beats the home one
    * > touch .eli.yml
      """
      skill:
        lines: 2
      """
    * > touch proj/.eli.yml
      """
      skill:
        lines: 3
      """
    * > touch long/SKILL.md
      """
      # Long

      Ok.
      Ok.
      """
    * > cd proj
    * > eli long
      | long/SKILL.md:4 skill.lines 4 > 3 |

  Scenario: the --config flag beats project and home configs
    * > touch .eli.yml
      """
      skill:
        lines: 2
      """
    * > touch proj/.eli.yml
      """
      skill:
        lines: 2
      """
    * > touch flag.yml
      """
      skill:
        lines: 3
      """
    * > touch long/SKILL.md
      """
      # Long

      Ok.
      Ok.
      """
    * > cd proj
    * > eli --config ../flag.yml long
      | long/SKILL.md:4 skill.lines 4 > 3 |

  Scenario: warn reports and exits 0
    * > touch .eli.yml
      """
      skill:
        width: [warn, 10]
      """
    * > touch wide/SKILL.md
      """
      # Wide

      Short.
      Ok.
      Fine.
      abcdefghijk
      """
    * > run wide
    * the exit code is 0
    * the output is exactly
      | wide/SKILL.md:6 skill.width 11 > 10 |

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
