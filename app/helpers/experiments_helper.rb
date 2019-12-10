module ExperimentsHelper
  # Approximate date check boxes only active on local/staging envs
  def approximate_dates_enabled?
    Rails.env.development? || ENV.key?('DEV_TOOLS_ENABLED')
  end

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
