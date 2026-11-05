Feature: Config

  Background:
    * > touch short/SKILL.md
      """
      ---
      name: short
      description: Fixture.
      ---
      """

  Scenario: the nearest config wins per key
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
      ## a

      - one
      - two

      ## b

      ## c
      """
    * > cd proj
    * > eli --config ../flag.yml mix
      """
      mix/SKILL.md:12 sections 3 > 2
      mix/SKILL.md:8 steps 2 > 1
      """

  Rule: invalid value

    Scenario: bad values are reported and exit 2
      * > touch .eli.yml
        """
        sections: of
        steps: [warn, x]
        step:
        bullet: 5
        """
      * > eli short
        """
        .eli.yml sections: invalid value "of"
        .eli.yml steps: invalid value ["warn","x"]
        .eli.yml step: invalid value null
        .eli.yml bullet: invalid value 5
        """

    Scenario Outline: a bad value is reported and exits 2
      * > touch .eli.yml
        """
        <config>
        """
      * > eli short
        """
        <output>
        """

      Examples:
        | config              | output                                     |
        | bullet: "1."        | .eli.yml bullet: invalid value "1."        |
        | bullet: [warn, "x"] | .eli.yml bullet: invalid value ["warn","x"] |
        | bullet: 5           | .eli.yml bullet: invalid value 5           |
        | sections: off       | .eli.yml sections: invalid value "off"     |

  Rule: unknown key

    Scenario: an old key exits 2
      * > touch .eli.yml
        """
        skill:
        width: 80
        """
      * > eli short
        """
        .eli.yml unknown rule skill
        .eli.yml unknown rule width
        """

  Rule: readme sample

    Scenario: the README config sample loads clean
      * > sample .eli.yml from the README
      * > eli short
        """
        """

  Rule: defaults

    Scenario: the defaults are 7 sections, 7 steps, 255 chars and a dash
      * > touch .eli.yml
        """
        """
      * > touch sections/SKILL.md
        """
        ---
        name: sections
        description: Fixture.
        ---
        ## a

        ## b

        ## c

        ## d

        ## e

        ## f

        ## g

        ## h
        """
      * > touch steps/SKILL.md
        """
        ---
        name: steps
        description: Fixture.
        ---
        ## a

        One.

        Two.

        Three.

        Four.

        Five.

        Six.

        Seven.

        Eight.
        """
      * > touch step/SKILL.md
        """
        ---
        name: step
        description: Fixture.
        ---
        ## a

        aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
        """
      * > touch bullet/SKILL.md
        """
        ---
        name: bullet
        description: Fixture.
        ---
        ## a

        * one
        """
      * > eli .
        """
        bullet/SKILL.md:7 bullet * > -
        sections/SKILL.md:19 sections 8 > 7
        step/SKILL.md:7 step 256 > 255
        steps/SKILL.md:21 steps 8 > 7
        """
