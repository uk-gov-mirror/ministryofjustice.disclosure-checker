Feature: Conviction
  Background:
    When I visit "/"
    And I click the "Start now" link
    Then I should see "Were you cautioned or convicted?"


  @happy_path
  Scenario: Conviction happy path
    When I choose "Convicted"
    Then I should see "How old were you when you got convicted?"
