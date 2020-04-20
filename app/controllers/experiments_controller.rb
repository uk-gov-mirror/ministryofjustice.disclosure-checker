class ExperimentsController < ApplicationController
  before_action :check_permissions, :reset_disclosure_check_session

  # :nocov:
  def enable_multiples
    cookies.permanent[:multiples_enabled] = 1
    redirect_to root_path
  end

  def disable_multiples
    cookies.delete :multiples_enabled
    redirect_to root_path
  end
  # :nocov:

  private

  def check_permissions
    raise 'For development use only' unless helpers.dev_tools_enabled?
  end
end
