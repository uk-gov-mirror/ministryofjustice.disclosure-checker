Feature: Caution
  Background:
    When I visit "/"
    Then I should see "Check if you need to disclose your criminal record"
    And I click the "Start now" link
    Then I should see "Did you get a caution or a conviction?"

  @happy_path
  Scenario: Caution happy path
    When I choose "Caution"
    Then I should see "When did you get the caution?"
    # TODO: to be continued...
