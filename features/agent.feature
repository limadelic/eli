Feature: agent

  Rule: width

    Scenario: an agent over its width fails, a skill keeps its own
      * > touch .eli.yml
        """
        agent:
          width: 60
        """
      * > touch mix/SKILL.md
        """
        ---
        name: mix
        description: Fixture.
        ---
        # Mix

        abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijk
        """
      * > touch mix/agents/x.md
        """
        ---
        name: x
        description: Fixture.
        ---
        # X

        abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghij
        abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijk
        """
      * > touch mix/notes.md
        """
        abcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghijabcdefghij
        """
      * > run mix
      * the exit code is 1
      * the output is exactly
        | mix/agents/x.md:8 agent.width 61 > 60 |

  Rule: lines

    Scenario: an agent at its lines passes, one over fails
      * > touch .eli.yml
        """
        agent:
          lines: 8
        """
      * > touch lines/agents/at.md
        """
        ---
        name: at
        description: Fixture.
        ---
        Ok.
        Ok.
        Ok.
        Ok.
        """
      * > touch lines/agents/over.md
        """
        ---
        name: over
        description: Fixture.
        ---
        Ok.
        Ok.
        Ok.
        Ok.
        Ok.
        """
      * > run lines
      * the exit code is 1
      * the output is exactly
        | lines/agents/over.md:9 agent.lines 9 > 8 |

  Rule: sections

    Scenario: an agent at its sections passes, one over fails
      * > touch .eli.yml
        """
        agent:
          sections: 2
        """
      * > touch sections/agents/at.md
        """
        ---
        name: at
        description: Fixture.
        ---
        ## a

        ## b
        """
      * > touch sections/agents/over.md
        """
        ---
        name: over
        description: Fixture.
        ---
        ## a

        ## b

        ## c
        """
      * > run sections
      * the exit code is 1
      * the output is exactly
        | sections/agents/over.md:9 agent.sections 3 > 2 |

  Rule: steps

    Scenario: an agent section uses its own steps, a skill uses the global
      * > touch .eli.yml
        """
        section:
          steps: 2
        agent:
          section:
            steps: 5
        """
      * > touch steps/agents/five.md
        """
        ---
        name: five
        description: Fixture.
        ---
        ## a

        - one
        - two
        - three
        - four
        - five
        """
      * > touch steps/agents/six.md
        """
        ---
        name: six
        description: Fixture.
        ---
        ## a

        - one
        - two
        - three
        - four
        - five
        - six
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
        - three
        """
      * > run steps
      * the exit code is 1
      * the output is exactly
        | steps/SKILL.md:11 section.steps 3 > 2 |
        | steps/agents/six.md:12 agent.section.steps 6 > 5 |
