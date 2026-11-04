Feature: Config

  Scenario: a rule set to off is skipped
    * > touch .eli.yml
      """
      sections: off
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
    * > touch flag.yml
      """
      max-foo:
        - error
      """
    * > touch short/SKILL.md
      """
      # Short
      """
    * > eli --config flag.yml short
      | flag.yml unknown rule max-foo |

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
    * > touch proj/mix/SKILL.md
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

  Rule: invalid value

    Scenario: bad values are reported and exit 2
      * > touch .eli.yml
        """
        section:
          width: of
          steps: [warn, x]
        step:
          lines:
        skill:
          lines: true
          sections: [loud, 3]
          section:
            steps: [warn]
            width: [warn, 3, 9]
        agent: 5
        """
      * > touch flag.yml
        """
        skill:
          width: wide
        """
      * > touch short/SKILL.md
        """
        # Short
        """
      * > run --config flag.yml --config .eli.yml short
      * the output is exactly
        | flag.yml skill.width: invalid value "wide" |
        | .eli.yml section.width: invalid value "of" |
        | .eli.yml section.steps: invalid value ["warn","x"] |
        | .eli.yml step.lines: invalid value null |
        | .eli.yml skill.lines: invalid value true |
        | .eli.yml skill.sections: invalid value ["loud",3] |
        | .eli.yml skill.section.steps: invalid value ["warn"] |
        | .eli.yml skill.section.width: invalid value ["warn",3,9] |
        | .eli.yml agent: invalid value 5 |
      * the exit code is 2

    Scenario: a bullet that is not a marker is reported and exit 2
      * > touch .eli.yml
        """
        bullet: "1."
        """
      * > touch short/SKILL.md
        """
        # Short
        """
      * > run short
      * the output is exactly
        | .eli.yml bullet: invalid value "1." |
      * the exit code is 2

  Rule: readme sample

    Scenario: the README config sample loads clean
      * > sample .eli.yml from the README
      * > touch short/SKILL.md
        """
        # Short
        """
      * > run short
      * the exit code is 0
      * the output is empty
