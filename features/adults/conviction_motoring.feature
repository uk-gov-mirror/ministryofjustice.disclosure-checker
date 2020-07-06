Feature: Adult Conviction
  Background:
    Given I am completing a basic 18 or over "Motoring" conviction
    Then I should see "What was your motoring conviction?"

  @happy_path
  Scenario Outline: Motoring convictions
    When I choose "<subtype>"

    Then I should see "Did you get an endorsement?"
    And I choose "Yes"

    Then I should see "When did the ban start?"
    And I enter the following date <ban_date>
    Then I should see "When did your disqualification end?"

    And I enter the following date <disqualification_date>
    Then I should be on "/steps/check/results"
    And I should see "This conviction <spent_date>"

    Examples:
      | subtype           | ban_date   | disqualification_date | spent_date                      |
      | Disqualification  | 01-01-2020 | 01-06-2020            | will be spent on 1 January 2025 |
      | Disqualification  | 01-01-1990 | 22-05-1990            | was spent on 1 January 1995     |

  @happy_path
  Scenario Outline: Motoring convictions without length
    When I choose "<subtype>"
    Then I should see "Did you get an endorsement?"

    And I choose "<endorsement>"
    Then I should see "<known_date_header>"

    And I enter the following date <ban_date>
    Then I should be on "/steps/check/results"
    And I should see "This conviction <spent_date>"

    Examples:
      | subtype                    | ban_date   | endorsement | known_date_header                        | spent_date     |
      | Fine                       | 01-01-2020 | Yes         | When were you given the fine?            | will be spent on 1 January 2025 |
      | Fine                       | 01-01-2020 | No          | When were you given the fine?            | will be spent on 1 January 2021 |
      | Fixed Penalty notice (FPN) | 01-01-2020 | Yes         | When was the endorsement given?          | will be spent on 1 January 2025 |
      | Penalty points             | 01-01-2020 | Yes         | When were you given the penalty points?  | will be spent on 1 January 2025 |
      | Penalty points             | 01-01-2020 | No          | When were you given the penalty points?  | will be spent on 1 January 2023 |

  @happy_path
  Scenario: Fixed Penalty notice (FPN) convictions without endorsement
    When I choose "Fixed Penalty notice (FPN)"

    Then I should see "Did you get an endorsement?"
    And I choose "No"

    Then I should be on "/steps/check/results"
    And I should see "This fixed penalty notice (FPN) was not a conviction"
