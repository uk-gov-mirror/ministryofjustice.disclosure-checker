module StartingPointStep
  extend ActiveSupport::Concern

  private

  def current_disclosure_check
    # Only the step including this concern should create a disclosure check
    # if there isn't one in the session - because it's the first
    super || initialize_disclosure_check
  end

  def update_navigation_stack
    # The step including this concern will reset the navigation stack
    # before re-initialising it in StepController#update_navigation_stack
    current_disclosure_check.navigation_stack = []
    super
  end
end
