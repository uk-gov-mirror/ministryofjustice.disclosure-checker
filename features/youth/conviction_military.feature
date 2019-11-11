@skip
Feature: Conviction

  @happy_path
  Scenario Outline: Military convictions with length
    Given I am completing a basic under 18 "Military" conviction
    Then I should see "What type of order were you given?"

    When I choose "<subtype>"
    Then I should see "<known_date_header>"

    And I enter a valid date
    Then I should see "<length_type_header>"

    And  I choose "Years"
    Then I should see "<length_header>"
    And I fill in "Number of years" with "5"

    Then I click the "Continue" button
    And I should be on "<result>"

    Examples:
      | subtype                  | known_date_header              | length_type_header                                           | length_header                     | result               |
      | Overseas community order | When were you given the order? | Was the length of the order given in weeks, months or years? | What was the length of the order? | /steps/check/results |
      | Service community order  | When were you given the order? | Was the length of the order given in weeks, months or years? | What was the length of the order? | /steps/check/results |

  @happy_path
  Scenario Outline: Military convictions without length
    Given I am completing a basic under 18 "Military" conviction
    Then I should see "What type of order were you given?"

    When I choose "<subtype>"
    Then I should see "<known_date_header>"

    And I enter a valid date
    Then I should be on "<result>"

    Examples:
      | subtype                  | known_date_header                  | result               |
      | Dismissal                | When were you given the dismissal? | /steps/check/results |
      | Service detention        | When were you given the detention? | /steps/check/results |
