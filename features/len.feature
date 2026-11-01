Feature: Len

  Background:
    * > touch .eli.yml
      """
      max-len:
        - error
        - max: 20
      """

  Scenario: a short skill passes
    * > touch short/SKILL.md
      """
      abcdefghijklmnopqrst
      """
    * > eli short

  Scenario: an emoji counts as one char
    * > touch emoji/SKILL.md
      """
      abcdefghijklmnopqrs🎸
      """
    * > eli emoji

  Scenario: a long skill fails
    * > touch long/SKILL.md
      """
      # Long

      abcdefghijklmnopqrstu
      """
    * > eli long
      | long/SKILL.md:3 len 21 > 20 max-len |

  Scenario: a fenced line passes
    * > touch fenced/SKILL.md
      """
      ```
      abcdefghijklmnopqrstuvwxyz1234
      ```
      """
    * > eli fenced

  Scenario: a url line passes
    * > touch url/SKILL.md
      """
      https://example.com/a/very/long/path
      """
    * > eli url
