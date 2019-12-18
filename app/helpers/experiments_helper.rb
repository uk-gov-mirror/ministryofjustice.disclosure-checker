module ExperimentsHelper
  # Bail journey only active on local/staging envs
  def bail_enabled?
    Rails.env.development? || ENV.key?('DEV_TOOLS_ENABLED')
  end

  def motoring_enabled?
    cookies[:motoring_enabled].present?
  end

  def multiples_enabled?
    cookies[:multiples_enabled].present?
  end
end
