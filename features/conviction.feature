Feature: Conviction
  Background:
    When I visit "/"
    Then I should see "Check if you need to disclose your criminal record"
    And I click the "Start now" link
    Then I should see "Did you get a caution or a conviction?"


  @happy_path
  Scenario: Conviction happy path
    When I choose "Conviction"
    Then I should see "How old were you when you got convicted?"
