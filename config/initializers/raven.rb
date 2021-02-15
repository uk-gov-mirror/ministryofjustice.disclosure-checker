# Will use SENTRY_DSN environment variable if set
Raven.configure do |config|
  config.environments = %w( production )
  config.silence_ready = true
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)

  # Ensure we get ActionView::MissingTemplate errors
  config.excluded_exceptions -= %w(
    ActionView::MissingTemplate
  )
end
