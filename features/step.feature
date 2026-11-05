Feature: step

  Rule: chars

    Scenario: a long step split over 2 lines fails
      * > touch .eli.yml
        """
        step: 20
        """
      * > touch long/SKILL.md
        """
        ---
        name: long
        description: Fixture.
        ---
        ## a
        aaaaaaaaaa
        bbbbbbbbbbbbbbb
        """
      * > eli long
        """
        long/SKILL.md:6 step 26 > 20
        """

    Scenario: a link counts only its label and inline code counts its text
      * > touch .eli.yml
        """
        step: 30
        """
      * > touch link/SKILL.md
        """
        ---
        name: link
        description: Fixture.
        ---
        ## a
        See [aaaaaaaaaa](https://example.com/a/very/long/address/that/must/not/count/at/all) and `bbbbbbbbbbbbbbb`.
        """
      * > eli link
        """
        link/SKILL.md:6 step 35 > 30
        """

    Scenario: a hard line break counts as one space
      * > touch .eli.yml
        """
        step: 2
        """
      * > touch break/SKILL.md
        """
        ---
        name: break
        description: Fixture.
        ---
        ## a
        x
        y

        z\
        w
        """
      * > eli break
        """
        break/SKILL.md:6 step 3 > 2
        break/SKILL.md:9 step 3 > 2
        """

  Rule: bullet

    Scenario Outline: a step with the wrong marker fails the bullet
      * > touch .eli.yml
        """
        bullet: "<bullet>"
        """
      * > touch marker/SKILL.md
        """
        ---
        name: marker
        description: Fixture.
        ---
        ## a
        <marker> one
        """
      * > eli marker
        """
        marker/SKILL.md:6 bullet <marker> > <bullet>
        """

      Examples:
        | marker | bullet |
        | 1.     | +      |
        | *      | +      |
        | +      | *      |

    Scenario: a mixed list does not report the item that matches the marker
      * > touch .eli.yml
        """
        bullet: "*"
        """
      * > touch dash/SKILL.md
        """
        ---
        name: dash
        description: Fixture.
        ---
        ## a
        * one
        - two
        """
      * > eli dash
        """
        dash/SKILL.md:7 bullet - > *
        """

  Rule: warn

    Scenario Outline: a warn value warns
      * > touch .eli.yml
        """
        <config>
        """
      * > touch warn/SKILL.md
        """
        ---
        name: warn
        description: Fixture.
        ---
        ## a
        One two three.

        - one
        """
      * > eli warn
        """
        <output>
        """

      Examples:
        | config              | output                             |
        | step: [warn, 5]     | warn/SKILL.md:6 warn step 14 > 5   |
        | bullet: [warn, "*"] | warn/SKILL.md:8 warn bullet - > *  |
