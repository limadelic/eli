Feature: step

  Rule: lines

    Scenario: a step over its lines fails
      * > touch .eli.yml
        """
        step: {lines: 2}
        """
      * > touch steps/SKILL.md
        """
        # Steps

        ## a

        - one
          two

        - one
          two
          three

        - one
          - two
          - three

        - one

          two
          three
        """
      * > run steps
      * the exit code is 1
      * the output is exactly
        | steps/SKILL.md:8 step.lines 3 > 2 |
        | steps/SKILL.md:16 step.lines 3 > 2 |

  Rule: chars

    Scenario: a long step split over many lines fails
      * > touch long/SKILL.md
        """
        # Long

        ## a

        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        bbbbbbbbbbbbbbb
        """
      * > run long
      * the exit code is 1
      * the output is exactly
        | long/SKILL.md:5 step 301 > 255 |

    Scenario: a link counts only its label
      * > touch .eli.yml
        """
        skill:
          width: off
        """
      * > touch link/SKILL.md
        """
        # Link

        ## a

        [aaaaaaaaaa aaaaaaaaaa aaaaaaaaaa aaaaaaaaaa aaaaaaaaaa aaaaaaaaaa aaaaaaaaaa aaaaaaaaaa aaaaaaaaaa aaaaaaaaaa aaaaaaaaaa aaaaaaaaaa aaaaaaaaaa aaaaaaaaaa aaaaaaaaaa aaaaaaaaaa aaaaaaaaaa aaaaaaaaaa aaaaaaaaaa aaaaaaaaaa aaaaaaaaaa aaaaaaaaaa aaaaaaaaaa aaaaaaaaaa aaaaaaaaaa aaaaaaaaaa bbbbbbbbbbbbbbb](https://example.com/a/very/long/address/that/must/not/count/at/all/so/it/is/long/enough/to/matter)
        """
      * > run link
      * the exit code is 1
      * the output is exactly
        | link/SKILL.md:5 step 301 > 255 |

    Scenario: the top-level step key sets the limit
      * > touch .eli.yml
        """
        step: 300
        """
      * > touch long/SKILL.md
        """
        # Long

        ## a

        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        bbbbbbbbbbbbbbb
        """
      * > run long
      * the exit code is 1
      * the output is exactly
        | long/SKILL.md:5 step 301 > 300 |
