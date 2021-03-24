Feature: Conviction
  Scenario Outline: Discharge
  When I am completing a basic 18 or over "Discharge" conviction
  Then I should see "What discharge were you given?"

  When I choose "<subtype>"
  Then I should see "<known_date_header>"

  And I enter a valid date
  Then I should see "<length_type_header>"

  And  I choose "Years"
  Then I should see "<length_header>"
  And I fill in "Number of years" with "10"

  Then I click the "Continue" button
  And I should be on "/steps/check/check_your_answers"
 Then I click the "Go to results page" link
  And I should be on "/steps/check/results"

  Examples:
    | subtype               | known_date_header                  | length_type_header                                                | length_header                         |
    | Conditional discharge | When were you given the discharge? | Was the length of the conditions given in weeks, months or years? | What was the length of the discharge? |
    | Bind over             | When were you given the order?     | Was the length of the order given in weeks, months or years?      | What was the length of the order?     |


  @happy_path
  Scenario: Conviction Discharge - Absolute discharge
    When I am completing a basic 18 or over "Discharge" conviction
    Then I should see "What discharge were you given?"
    And I choose "Absolute discharge"
    Then I should see subsection "Absolute discharge"
    And I should see "When were you given the discharge?"

    When I enter a valid date
    And I should be on "/steps/check/check_your_answers"
   Then I click the "Go to results page" link
    And I should be on "/steps/check/results"
