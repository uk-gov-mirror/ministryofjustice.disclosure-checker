class ApplicationController < ActionController::Base
  include ErrorHandling

  def current_disclosure_check
    @_current_disclosure_check ||= DisclosureCheck.find_by_id(session[:disclosure_check_id])
  end
  helper_method :current_disclosure_check

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
