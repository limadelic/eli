Feature: section

  Rule: width

    Scenario: section width beats the skill width
      * > touch .eli.yml
        """
        skill:
          width: 60
        section:
          width: [warn, 70]
        """
      * > touch wide/SKILL.md
        """
        ---
        name: wide
        description: Fixture.
        ---
        # Wide

        abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghij
        abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcde

        ## Part

        abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghij
        abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghija
        Short.
        """
      * > run wide
      * the exit code is 1
      * the output is exactly
        | wide/SKILL.md:8 skill.width 65 > 60 |
        | wide/SKILL.md:13 warn section.width 71 > 70 |

    Scenario: nested beats section, off skips only its own lines
      * > touch .eli.yml
        """
        skill:
          width: off
          section:
            width: 100
        code:
          width: 80
        section:
          width: 70
        """
      * > touch wide/SKILL.md
        """
        ---
        name: wide
        description: Fixture.
        ---
        # Wide

        Short.

        abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghij

        ## Part

        abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghij
        abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghija

        ```
        abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghija
        ```
        """
      * > run wide
      * the exit code is 1
      * the output is exactly
        | wide/SKILL.md:14 skill.section.width 101 > 100 |
        | wide/SKILL.md:17 code.width 81 > 80 |

    Scenario: severity per element
      * > touch .eli.yml
        """
        skill:
          width: [warn, 60]
        section:
          width: off
        """
      * > touch wide/SKILL.md
        """
        ---
        name: wide
        description: Fixture.
        ---
        # Wide

        abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcde

        ## Part

        abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghij
        """
      * > run wide
      * the exit code is 0
      * the output is exactly
        | wide/SKILL.md:7 warn skill.width 65 > 60 |

  Rule: steps

    Scenario: a section over its steps fails
      * > touch .eli.yml
        """
        section:
          steps: 2
        """
      * > touch steps/SKILL.md
        """
        ---
        name: steps
        description: Fixture.
        ---
        # Steps

        ## a

        - one
        - two

        ## b

        - three
        - four
        - five
          - five a
          - five b
        """
      * > run steps
      * the exit code is 1
      * the output is exactly
        | steps/SKILL.md:16 section.steps 3 > 2 |

    Scenario: a section over the top-level steps fails
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

        Five.

        Six.

        Seven.

        Eight.
        """
      * > run many
      * the exit code is 1
      * the output is exactly
        | many/SKILL.md:23 steps 8 > 7 |

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

  Rule: sections

    Scenario: a file over the top-level sections fails
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

        ## e

        ## f

        ## g

        ## h
        """
      * > eli wide
        | wide/SKILL.md:21 sections 8 > 7 |
      * the exit code is 1

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
