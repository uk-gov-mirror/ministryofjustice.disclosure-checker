Feature: Conviction
  Scenario Outline: Hospital or guardianship order
    Given I am completing a basic under 18 "Hospital or guardianship order" conviction
    Then I should see "What type of order were you given?"
    And I choose "<subtype>"
    Then I should see "When were you given the order?"

    When I enter a valid date
    Then I should see "Was the length of the order given in weeks, months or years?"
    And I choose "Weeks"

    Then I should see "What was the length of the order?"
    And I fill in "Number of weeks" with "18"

    Then I click the "Continue" button
    Then I should be on "<result>"

  Examples:
    | subtype            | result               |
    | Hospital order     | /steps/check/results |
    | Guardianship order | /steps/check/results |