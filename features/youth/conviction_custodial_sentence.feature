Feature: Conviction

  @happy_path
  Scenario Outline: Prison sentences (bailable)
    When I am completing a basic under 18 "Custody or hospital order" conviction
    Then I should see "What sentence were you given?"

    When I choose "<subtype>"
    Then I should see "Did you spend any time on bail with an electronic tag?"

    And I choose "Yes"
    Then I should see "How many days spent with an electronic tag counted towards your sentence?"

    And I fill in "Number of days" with "10"
    And I click the "Continue" button
    Then I should see "<known_date_header>"

    And I enter a valid date
    Then I should see "<length_type_header>"

    And  I choose "Years"
    Then I should see "<length_header>"
    And I fill in "Number of years" with "2"

    Then I click the "Continue" button
    And I should be on "<result>"

    Examples:
      | subtype                            | known_date_header             | length_type_header                                               | length_header                         | result               |
      | Detention and training order (DTO) | When did the DTO start?       | Was the length of the DTO given in weeks, months or years?       | What was the length of the DTO?       | /steps/check/results |
      | Detention                          | When did the detention start? | Was the length of the detention given in weeks, months or years? | What was the length of the detention? | /steps/check/results |


  @happy_path
  Scenario Outline: Hospital orders (non-bailable)
    When I am completing a basic under 18 "Custody or hospital order" conviction
    Then I should see "What sentence were you given?"

    When I choose "<subtype>"
    Then I should see "<known_date_header>"

    And I enter a valid date
    Then I should see "<length_type_header>"

    And  I choose "Years"
    Then I should see "<length_header>"
    And I fill in "Number of years" with "2"

    Then I click the "Continue" button
    And I should be on "<result>"

    Examples:
      | subtype        | known_date_header              | length_type_header                                           | length_header                     | result               |
      | Hospital order | When were you given the order? | Was the length of the order given in weeks, months or years? | What was the length of the order? | /steps/check/results |
