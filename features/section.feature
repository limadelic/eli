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
        | wide/SKILL.md:4 skill.width 65 > 60 |
        | wide/SKILL.md:9 warn section.width 71 > 70 |

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
        | wide/SKILL.md:10 skill.section.width 101 > 100 |
        | wide/SKILL.md:13 code.width 81 > 80 |

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
        # Wide

        abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcde

        ## Part

        abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghij
        """
      * > run wide
      * the exit code is 0
      * the output is exactly
        | wide/SKILL.md:3 warn skill.width 65 > 60 |

  Rule: steps

    Scenario: a section over its steps fails
      * > touch .eli.yml
        """
        section:
          steps: 2
        """
      * > touch steps/SKILL.md
        """
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
        | steps/SKILL.md:12 section.steps 3 > 2 |
  Rule: sections

    Scenario: a file over the top-level sections fails
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
        | wide/SKILL.md:17 sections 8 > 7 |

    Scenario: the top-level sections key sets the limit
      * > touch .eli.yml
        """
        sections: 2
        """
      * > touch many/SKILL.md
        """
        # Many

        ## a

        ## b

        ## c
        """
      * > run many
      * the exit code is 1
      * the output is exactly
        | many/SKILL.md:7 sections 3 > 2 |
