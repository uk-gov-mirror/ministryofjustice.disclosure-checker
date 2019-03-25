module ErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from Exception do |exception|
      case exception
      when Errors::InvalidSession, ActionController::InvalidAuthenticityToken
        redirect_to invalid_session_errors_path
      when Errors::CheckCompleted
        redirect_to check_completed_errors_path
      else
        raise if Rails.application.config.consider_all_requests_local

        Raven.capture_exception(exception)
        redirect_to unhandled_errors_path
      end
    end
  end

  private

  def check_disclosure_check_presence
    raise Errors::InvalidSession unless current_disclosure_check
  end

  def check_disclosure_check_not_completed
    raise Errors::CheckCompleted if current_disclosure_check.completed?
  end
end
