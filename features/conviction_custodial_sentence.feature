Feature: Conviction
  Background:
    When I am completing a basic under 18 "Custodial sentence" conviction
    Then I should see "What was your custodial sentence?"

  @happy_path
  Scenario: Conviction Custodial sentence - Detention and training order
    And I choose "Detention and training order"
    Then I should see "When were you given the detention and training order (DTO)?"

    When I enter a valid date

    Then I should see "Was the length of the detention and training order (DTO) given in weeks, months or years?"
    And I choose "Weeks"

    Then I should see "What was the length of the detention and training order (DTO)?"
    And I fill in "Number of weeks" with "10"

    Then I click the "Continue" button
    And I should be on "/steps/check/results"

  @happy_path
  Scenario: Conviction Custodial sentence - Detention
    And I choose "Detention"
    Then I should see "When were you given the detention?"

    When I enter a valid date

    Then I should see "Was the length of the detention given in weeks, months or years?"
    And I choose "Months"

    Then I should see "What was the length of the detention?"
    And I fill in "Number of months" with "3"

    Then I click the "Continue" button
    And I should be on "/steps/check/results"