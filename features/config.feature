Feature: Config

  Scenario: an unknown rule id is reported
    * > touch flag.yml
      """
      max-foo:
        - error
      """
    * > touch short/SKILL.md
      """
      ---
      name: short
      description: Fixture.
      ---
      # Short
      """
    * > eli --config flag.yml short
      | flag.yml unknown rule max-foo |

  Scenario: the nearest config wins per key
    * > touch ../.eli.yml
      """
      sections: 1
      """
    * > touch .eli.yml
      """
      sections: 4
      steps: 5
      """
    * > touch proj/.eli.yml
      """
      sections: 2
      """
    * > touch flag.yml
      """
      steps: 1
      """
    * > touch proj/mix/SKILL.md
      """
      ---
      name: mix
      description: Fixture.
      ---
      # Mix

      ## a

      - one
      - two

      ## b

      ## c
      """
    * > cd proj
    * > run --config ../flag.yml mix
    * the exit code is 1
    * the output is exactly
      | mix/SKILL.md:14 sections 3 > 2 |
      | mix/SKILL.md:10 steps 2 > 1 |

  Rule: invalid value

    Scenario: bad values are reported and exit 2
      * > touch .eli.yml
        """
        sections: of
        steps: [warn, x]
        step:
        bullet: 5
        """
      * > touch short/SKILL.md
        """
        ---
        name: short
        description: Fixture.
        ---
        # Short
        """
      * > run short
      * the output is exactly
        | .eli.yml sections: invalid value "of" |
        | .eli.yml steps: invalid value ["warn","x"] |
        | .eli.yml step: invalid value null |
        | .eli.yml bullet: invalid value 5 |
      * the exit code is 2

    Scenario: a bullet that is not a marker is reported and exit 2
      * > touch .eli.yml
        """
        bullet: "1."
        """
      * > touch short/SKILL.md
        """
        ---
        name: short
        description: Fixture.
        ---
        # Short
        """
      * > run short
      * the output is exactly
        | .eli.yml bullet: invalid value "1." |
      * the exit code is 2

    Scenario: a bullet pair with a non-marker is reported and exit 2
      * > touch .eli.yml
        """
        bullet: [warn, "x"]
        """
      * > touch short/SKILL.md
        """
        ---
        name: short
        description: Fixture.
        ---
        # Short
        """
      * > run short
      * the output is exactly
        | .eli.yml bullet: invalid value ["warn","x"] |
      * the exit code is 2

    Scenario: off is not a value and exits 2
      * > touch .eli.yml
        """
        sections: off
        """
      * > touch short/SKILL.md
        """
        ---
        name: short
        description: Fixture.
        ---
        # Short
        """
      * > run short
      * the output is exactly
        | .eli.yml sections: invalid value "off" |
      * the exit code is 2

  Rule: unknown key

    Scenario: an old key exits 2
      * > touch .eli.yml
        """
        skill:
          sections: 2
        width: 80
        """
      * > touch short/SKILL.md
        """
        ---
        name: short
        description: Fixture.
        ---
        # Short
        """
      * > run short
      * the output is exactly
        | .eli.yml unknown rule skill |
        | .eli.yml unknown rule width |
      * the exit code is 2

  Rule: readme sample

    Scenario: the README config sample loads clean
      * > sample .eli.yml from the README
      * > touch short/SKILL.md
        """
        ---
        name: short
        description: Fixture.
        ---
        # Short
        """
      * > run short
      * the exit code is 0
      * the output is empty
