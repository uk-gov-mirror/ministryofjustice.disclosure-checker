class ApplicationController < ActionController::Base
  include ErrorHandling
  include SecurityHandling

  def current_disclosure_check
    @_current_disclosure_check ||= DisclosureCheck.find_by_id(session[:disclosure_check_id])
  end
  helper_method :current_disclosure_check

  def previous_step_path
    # Second to last element in the array, will be nil for arrays of size 0 or 1
    current_disclosure_check&.navigation_stack&.slice(-2) || root_path
  end
  helper_method :previous_step_path

  private

  def reset_disclosure_check_session
    session.delete(:disclosure_check_id)
    session.delete(:last_seen)
  end

  def initialize_disclosure_check(attributes = {})
    DisclosureCheck.create(attributes).tap do |disclosure_check|
      session[:disclosure_check_id] = disclosure_check.id
    end
  end
end
