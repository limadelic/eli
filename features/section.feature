Feature: section

  Rule: sections

    Scenario: a file over the top-level sections fails
      * > touch .eli.yml
        """
        sections: 3
        """
      * > touch wide/SKILL.md
        """
        ---
        name: wide
        description: Fixture.
        ---
        # Wide

        ## a

        ## b

        ## c

        ## d
        """
      * > run wide
      * the exit code is 1
      * the output is exactly
        | wide/SKILL.md:13 sections 4 > 3 |

    Scenario: the top-level sections key sets the limit
      * > touch .eli.yml
        """
        sections: 2
        """
      * > touch many/SKILL.md
        """
        ---
        name: many
        description: Fixture.
        ---
        # Many

        ## a

        ## b

        ## c
        """
      * > run many
      * the exit code is 1
      * the output is exactly
        | many/SKILL.md:11 sections 3 > 2 |

    Scenario: a warn sections value warns and exits 0
      * > touch .eli.yml
        """
        sections: [warn, 2]
        """
      * > touch many/SKILL.md
        """
        ---
        name: many
        description: Fixture.
        ---
        # Many

        ## a

        ## b

        ## c
        """
      * > run many
      * the exit code is 0
      * the output is exactly
        | many/SKILL.md:11 warn sections 3 > 2 |

  Rule: steps

    Scenario: a section over the top-level steps fails
      * > touch .eli.yml
        """
        steps: 3
        """
      * > touch many/SKILL.md
        """
        ---
        name: many
        description: Fixture.
        ---
        # Many

        ## a

        One.

        Two.

        Three.

        Four.
        """
      * > run many
      * the exit code is 1
      * the output is exactly
        | many/SKILL.md:15 steps 4 > 3 |

    Scenario: the top-level steps key sets the limit
      * > touch .eli.yml
        """
        steps: 2
        """
      * > touch few/SKILL.md
        """
        ---
        name: few
        description: Fixture.
        ---
        # Few

        ## a

        One.

        Two.

        Three.
        """
      * > run few
      * the exit code is 1
      * the output is exactly
        | few/SKILL.md:13 steps 3 > 2 |

    Scenario: a warn steps value warns and exits 0
      * > touch .eli.yml
        """
        steps: [warn, 2]
        """
      * > touch few/SKILL.md
        """
        ---
        name: few
        description: Fixture.
        ---
        # Few

        ## a

        One.

        Two.

        Three.
        """
      * > run few
      * the exit code is 0
      * the output is exactly
        | few/SKILL.md:13 warn steps 3 > 2 |

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
        # Mixed

        ## a

        - one
        - two

        Three.

        | a | b |
        | - | - |
        | 1 | 2 |

        ```
        code
        ```
        """
      * > run mixed
      * the exit code is 1
      * the output is exactly
        | mixed/SKILL.md:14 steps 5 > 3 |
