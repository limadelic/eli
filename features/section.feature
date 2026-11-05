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
      * > run many
      * the exit code is <exit>
      * the output is exactly
        | <output> |

      Examples:
        | config    | exit | output                              |
        | 2         | 1    | many/SKILL.md:7 sections 3 > 2      |
        | [warn, 2] | 0    | many/SKILL.md:7 warn sections 3 > 2 |

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
      * > run few
      * the exit code is <exit>
      * the output is exactly
        | <output> |

      Examples:
        | config    | exit | output                             |
        | 2         | 1    | few/SKILL.md:10 steps 3 > 2        |
        | [warn, 2] | 0    | few/SKILL.md:10 warn steps 3 > 2   |

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
      * > run mixed
      * the exit code is 1
      * the output is exactly
        | mixed/SKILL.md:11 steps 5 > 3 |
