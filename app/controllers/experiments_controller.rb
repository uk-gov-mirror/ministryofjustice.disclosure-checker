class ExperimentsController < ApplicationController
  before_action :check_permissions, :reset_disclosure_check_session

  private

  def check_permissions
    raise 'For development use only' unless helpers.dev_tools_enabled?
  end
end
