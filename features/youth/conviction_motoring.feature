Feature: Youth Conviction
  Background:
    Given I am completing a basic under 18 "Motoring" conviction
    Then I should see "What was your motoring conviction?"

  @happy_path
  Scenario: Lifetime Motoring convictions
    When I choose "Disqualification"

    Then I should see "Were you given a lifetime ban?"
    And I choose "Yes"

    Then I should be on "/steps/check/results"
    And I should see "This conviction will never be spent"

  @happy_path
  Scenario Outline: Motoring convictions
    When I choose "<subtype>"
    Then I should see "Were you given a lifetime ban?"
    And I choose "No"

    Then I should see "Did you get an endorsement?"
    And I choose "Yes"

    Then I should see "<known_date_header>"
    And I enter the following date 01-01-2020

    Then I should see "<motoring_disqualification_end_date_header>"
    And I enter the following date <disqualification_date>

    Then I should be on "<result>"
    And I should see "<spent_date>"

    Examples:
      | subtype           | known_date_header          | motoring_disqualification_end_date_header | disqualification_date | result               | spent_date                                   |
      | Disqualification  | When did the ban start?    | When did your disqualification end?       | 01-06-2020            | /steps/check/results | This conviction will be spent on 1 July 2022 |
      | Disqualification  | When did the ban start?    | When did your disqualification end?       | 22-05-2023            | /steps/check/results | This conviction will be spent on 22 May 2023 |

  @happy_path
  Scenario Outline: Motoring convictions without length
    When I choose "<subtype>"

    Then I should see "Did you get an endorsement?"
    And I choose "<endorsement>"

    Then I should see "<known_date_header>"
    And I enter the following date 01-01-2020

    Then I should be on "<result>"
    And I should see "<spent_date>"

    Examples:
      | subtype                    | endorsement | known_date_header                        | result               | spent_date                                      |
      | Fine                       | Yes         | When were you given the fine?            | /steps/check/results | This conviction will be spent on 1 July 2022    |
      | Fine                       | No          | When were you given the fine?            | /steps/check/results | This conviction will be spent on 1 July 2020    |
      | Fixed Penalty notice (FPN) | Yes         | When was the endorsement given?          | /steps/check/results | This conviction will be spent on 1 July 2022    |
      | Penalty points             | Yes         | When were you given the penalty points?  | /steps/check/results | This conviction will be spent on 1 January 2023 |
      | Penalty points             | No          | When were you given the penalty points?  | /steps/check/results | This conviction will be spent on 1 January 2023 |

  @happy_path
  Scenario: Fixed Penalty notice (FPN) convictions without endorsement
    When I choose "Fixed Penalty notice (FPN)"

    Then I should see "Did you get an endorsement?"
    And I choose "No"

    Then I should be on "/steps/check/results"
    And I should see "This fixed penalty notice (FPN) was not a conviction"
