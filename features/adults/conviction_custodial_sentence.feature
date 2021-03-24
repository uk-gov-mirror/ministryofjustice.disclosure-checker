Feature: Conviction

  @happy_path @date_travel
  Scenario Outline: Prison sentences (bailable)
    Given The current date is 03-07-2020
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
    And I should be on "/steps/check/check_your_answers"
   Then I click the "Go to results page" link
    And I should be on "/steps/check/results"
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
    And I should be on "/steps/check/check_your_answers"
   Then I click the "Go to results page" link
    And I should be on "/steps/check/results"

    Examples:
      | subtype        | known_date_header              | length_type_header                                           | length_header                     |
      | Hospital order | When were you given the order? | Was the length of the order given in weeks, months or years? | What was the length of the order? |

  @happy_path @date_travel
  Scenario Outline: Hospital orders (with no length or indefinite length)
    Given The current date is 15-12-2020
    When I am completing a basic 18 or over "Custody or hospital order" conviction

    Then I should see "What sentence were you given?"

    When I choose "<subtype>"
    Then I should see "<known_date_header>"

    And I enter the following date 01-01-2020
    Then I should see "<length_type_header>"

    When I choose "<length_type>"
     And I should be on "/steps/check/check_your_answers"
    Then I click the "Go to results page" link
     And I should be on "/steps/check/results"
    Then I should see "<result>"

    Examples:
      | subtype        | known_date_header              | length_type_header                                           | length_type         | result                                                                                              |
      | Hospital order | When were you given the order? | Was the length of the order given in weeks, months or years? | No length was given | This conviction will be spent on 1 January 2022                                                     |
      | Hospital order | When were you given the order? | Was the length of the order given in weeks, months or years? | Until further order | This conviction is not spent and will stay in place until another order is made to change or end it |
