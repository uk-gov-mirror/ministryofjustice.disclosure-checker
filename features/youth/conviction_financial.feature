Feature: Conviction
  Background:
    When I am completing a basic under 18 "Financial penalty" conviction

  @happy_path
  Scenario: Conviction Financial penalty - Fine
    When I choose "A fine"
    Then I should see "When were you given the order?"
    When I enter a valid date
    Then I should be on "/steps/check/results"
    # Following step just as a smoke test. No need to add it to all the scenarios.
    And I should not see "This date is correct if you served your sentence in full"

  @happy_path
  Scenario: Conviction Financial penalty - Compensation paid in full
    When I choose "Compensation to a victim"
    Then I should see "Did you pay the compensation in full?"
    And I choose "Yes"

    Then I should see "When did you pay the compensation in full?"

    When I enter a valid date
    Then I should be on "/steps/check/results"

  @happy_path
  Scenario: Conviction Financial penalty - Compensation not paid in full
    When I choose "Compensation to a victim"
    Then I should see "Did you pay the compensation in full?"
    And I choose "No"
    Then I should be on "/steps/conviction/compensation_not_paid"
