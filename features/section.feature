Feature: section

  Rule: sections

    Scenario Outline: the top-level sections key sets the limit
      * > touch .eli.yml
        """
        sections: <config>
        """
      * > touch many/SKILL.md
        """
        ---
        name: many
        description: Fixture.
        ---
        ## a
        ## b
        ## c
        """
      * > eli many
        """
        <output>
        """

      Examples:
        | config    | output                              |
        | 2         | many/SKILL.md:7 sections 3 > 2      |

  Rule: steps

    Scenario Outline: the top-level steps key sets the limit
      * > touch .eli.yml
        """
        steps: <config>
        """
      * > touch few/SKILL.md
        """
        ---
        name: few
        description: Fixture.
        ---
        ## a
        One.

        Two.

        Three.
        """
      * > eli few
        """
        <output>
        """

      Examples:
        | config    | output                             |
        | 2         | few/SKILL.md:10 steps 3 > 2        |

    Scenario: the top-level steps count bullets, paragraphs, tables and code
      * > touch .eli.yml
        """
        steps: 3
        """
      * > touch mixed/SKILL.md
        """
        ---
        name: mixed
        description: Fixture.
        ---
        ## a
        - one
        - two

        Three.

        | a | b |
        | - | - |

        ```
        code
        ```
        """
      * > eli mixed
        """
        mixed/SKILL.md:11 steps 5 > 3
        """
