class PilotController < ApplicationController
  skip_before_action :check_http_credentials
  before_action :validate_reference,
                :increment_access_count

  # We maintain this controller/url as some users still access through it.
  # But we do not show a landing page anymore, we just redirect to the home.
  def show
    redirect_to root_url
  end

  private

  def reference
    params[:id].to_s
  end

  def validate_reference
    Participant.valid_reference?(reference) ||
      (raise "Participant reference not found: '#{reference}'")
  end

  def increment_access_count
    Participant.touch_or_create_by(reference: reference)
  end
end
