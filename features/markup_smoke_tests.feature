Feature: High level form markup smoke tests
  Background:
    Given I have started an application

  Scenario Outline: Form markup should be correct
    When I visit "<step_path>"

    Then The form markup should match "<fixture_file>"
    Then The form markup with errors should match "<error_fixture_file>"

    Examples:
      | step_path        | fixture_file     | error_fixture_file           |
      | steps/check/kind | steps_check_kind | steps_check_kind_with_errors |

  # cover date , checkbox and radio button forms
