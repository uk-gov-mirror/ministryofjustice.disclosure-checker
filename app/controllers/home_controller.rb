class HomeController < ApplicationController
  before_action :existing_disclosure_check_warning, :reset_disclosure_check_session

  def index; end

  private

  def in_progress_enough?
    current_disclosure_check&.in_progress? &&
      current_disclosure_check.navigation_stack.size > 1
  end

  def existing_disclosure_check_warning
    return unless in_progress_enough? && !params.key?(:new)

    redirect_to warning_reset_session_path
  end
end
