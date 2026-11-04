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

    Scenario: a hard line break counts as one space
      * > touch .eli.yml
        """
        step: 2
        """
      * > touch break/SKILL.md
        """
        # Break

        ## a

        x  
        y

        z\
        w
        """
      * > run break
      * the exit code is 1
      * the output is exactly
        | break/SKILL.md:5 step 3 > 2 |
        | break/SKILL.md:8 step 3 > 2 |

    Scenario: inline code chars count toward the step
      * > touch .eli.yml
        """
        step: 25
        """
      * > touch code/SKILL.md
        """
        # Code

        ## a

        Use `aaaaaaaaaaaaaaaaaaaa` here.
        """
      * > run code
      * the exit code is 1
      * the output is exactly
        | code/SKILL.md:5 step 30 > 25 |

  Rule: bullet

    Scenario: a numbered step fails the default bullet
      * > touch numbered/SKILL.md
        """
        # Numbered

        ## a

        1. one
        2. two
        """
      * > run numbered
      * the exit code is 1
      * the output is exactly
        | numbered/SKILL.md:5 bullet 1. > - |
        | numbered/SKILL.md:6 bullet 2. > - |

    Scenario: a star step fails the default bullet
      * > touch star/SKILL.md
        """
        # Star

        ## a

        * one
        """
      * > run star
      * the exit code is 1
      * the output is exactly
        | star/SKILL.md:5 bullet * > - |

    Scenario: a plus step fails the default bullet
      * > touch plus/SKILL.md
        """
        # Plus

        ## a

        + one
        """
      * > run plus
      * the exit code is 1
      * the output is exactly
        | plus/SKILL.md:5 bullet + > - |

    Scenario: the top-level bullet key sets the marker
      * > touch .eli.yml
        """
        bullet: "*"
        """
      * > touch dash/SKILL.md
        """
        # Dash

        ## a

        * one
        - two
        """
      * > run dash
      * the exit code is 1
      * the output is exactly
        | dash/SKILL.md:6 bullet - > * |
