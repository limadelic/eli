Feature: Lines

  Scenario: a long skill fails
    * > eli long
      | long/SKILL.md:6 lines 6 > 5 |

  Scenario: a short skill passes
    * > eli short
