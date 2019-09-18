class PilotController < ApplicationController
  skip_before_action :check_http_credentials
  before_action :validate_reference,
                :increment_access_count

  def show; end

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
