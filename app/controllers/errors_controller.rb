class ErrorsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def invalid_session
    respond_with_status(:not_found)
  end

  def not_found
    respond_with_status(:not_found)
  end

  def results_not_found
    respond_with_status(:not_found)
  end

  def report_completed
    respond_with_status(:unprocessable_entity)
  end

  def unhandled
    respond_with_status(:internal_server_error)
  end

  private

  def respond_with_status(status)
    respond_to do |format|
      format.html
      format.all { head status }
    end
  end
end
