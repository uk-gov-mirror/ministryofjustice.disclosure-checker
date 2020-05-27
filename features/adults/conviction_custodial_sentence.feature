Feature: Conviction

  @happy_path
  Scenario Outline: Prison sentences (bailable)
    When I am completing a basic 18 or over "Custody or hospital order" conviction
    Then I should see "What sentence were you given?"

    When I choose "<subtype>"
    Then I should see "Did you spend any time on bail with an electronic tag?"

    And I choose "Yes"
    Then I should see "How many days spent with an electronic tag counted towards your sentence?"

    And I fill in "Number of days" with "10"
    And I click the "Continue" button
    Then I should see "<known_date_header>"

    And I enter the following date 01-01-2020
    Then I should see "<length_type_header>"

    And  I choose "Months"
    Then I should see "<length_header>"
    And I fill in "Number of months" with "22"

    Then I click the "Continue" button
    And I should see "<result>"

    Examples:
      | subtype                   | known_date_header            | length_type_header                                              | length_header                        | result                                           |
      | Prison sentence           | When did the sentence start? | Was the length of the sentence given in weeks, months or years? | What was the length of the sentence? | This conviction will be spent on 21 October 2025 |
      | Suspended prison sentence | When did the sentence start? | Was the length of the sentence given in weeks, months or years? | What was the length of the sentence? | This conviction will be spent on 21 October 2025 |


  @happy_path
  Scenario Outline: Hospital orders (non-bailable)
    When I am completing a basic 18 or over "Custody or hospital order" conviction
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
