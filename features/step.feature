Feature: step

  Rule: chars

    Scenario: a long step split over many lines fails
      * > touch .eli.yml
        """
        step: 40
        """
      * > touch long/SKILL.md
        """
        ---
        name: long
        description: Fixture.
        ---
        # Long

        ## a

        aaaaaaaaaa
        aaaaaaaaaa
        aaaaaaaaaa
        bbbbbbbbbbbbbbb
        """
      * > run long
      * the exit code is 1
      * the output is exactly
        | long/SKILL.md:9 step 48 > 40 |

    Scenario: a link counts only its label
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
        # Link

        ## a

        [aaaaaaaaaa aaaaaaaaaa bbbbbbbbbbbbbbb](https://example.com/a/very/long/address/that/must/not/count/at/all/so/it/is/long/enough/to/matter)
        """
      * > run link
      * the exit code is 1
      * the output is exactly
        | link/SKILL.md:9 step 37 > 30 |

    Scenario: the top-level step key sets the limit
      * > touch .eli.yml
        """
        step: 300
        """
      * > touch long/SKILL.md
        """
        ---
        name: long
        description: Fixture.
        ---
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
        | long/SKILL.md:9 step 301 > 300 |

    Scenario: a warn step value warns and exits 0
      * > touch .eli.yml
        """
        step: [warn, 5]
        """
      * > touch short/SKILL.md
        """
        ---
        name: short
        description: Fixture.
        ---
        # Short

        ## a

        One two three.
        """
      * > run short
      * the exit code is 0
      * the output is exactly
        | short/SKILL.md:9 warn step 14 > 5 |

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
        | break/SKILL.md:9 step 3 > 2 |
        | break/SKILL.md:12 step 3 > 2 |

    Scenario: inline code chars count toward the step
      * > touch .eli.yml
        """
        step: 25
        """
      * > touch code/SKILL.md
        """
        ---
        name: code
        description: Fixture.
        ---
        # Code

        ## a

        Use `aaaaaaaaaaaaaaaaaaaa` here.
        """
      * > run code
      * the exit code is 1
      * the output is exactly
        | code/SKILL.md:9 step 30 > 25 |

  Rule: bullet

    Scenario: a numbered step fails the bullet marker
      * > touch .eli.yml
        """
        bullet: "+"
        """
      * > touch numbered/SKILL.md
        """
        ---
        name: numbered
        description: Fixture.
        ---
        # Numbered

        ## a

        1. one
        2. two
        """
      * > run numbered
      * the exit code is 1
      * the output is exactly
        | numbered/SKILL.md:9 bullet 1. > + |
        | numbered/SKILL.md:10 bullet 2. > + |

    Scenario: a star step fails the bullet marker
      * > touch .eli.yml
        """
        bullet: "+"
        """
      * > touch star/SKILL.md
        """
        ---
        name: star
        description: Fixture.
        ---
        # Star

        ## a

        * one
        """
      * > run star
      * the exit code is 1
      * the output is exactly
        | star/SKILL.md:9 bullet * > + |

    Scenario: a plus step fails the bullet marker
      * > touch .eli.yml
        """
        bullet: "*"
        """
      * > touch plus/SKILL.md
        """
        ---
        name: plus
        description: Fixture.
        ---
        # Plus

        ## a

        + one
        """
      * > run plus
      * the exit code is 1
      * the output is exactly
        | plus/SKILL.md:9 bullet + > * |

    Scenario: the top-level bullet key sets the marker
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
        # Dash

        ## a

        * one
        - two
        """
      * > run dash
      * the exit code is 1
      * the output is exactly
        | dash/SKILL.md:10 bullet - > * |

    Scenario: a warn bullet value warns and exits 0
      * > touch .eli.yml
        """
        bullet: [warn, "*"]
        """
      * > touch dash/SKILL.md
        """
        ---
        name: dash
        description: Fixture.
        ---
        # Dash

        ## a

        - one
        - two
        """
      * > run dash
      * the exit code is 0
      * the output is exactly
        | dash/SKILL.md:9 warn bullet - > * |
        | dash/SKILL.md:10 warn bullet - > * |
