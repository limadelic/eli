Feature: Lines

  Scenario: a long skill fails
    * > eli long
      | long/SKILL.md:10 lines 10 > 9 |

  Scenario: a short skill passes
    * > eli short
