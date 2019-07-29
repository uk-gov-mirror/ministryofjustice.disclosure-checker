module AnalyticsHelper
  CUSTOM_DIMENSIONS_MAP ||= {
    spent: :dimension1,
  }.freeze

  def analytics_tracking_id
    ENV['GA_TRACKING_ID']
  end

  def track_transaction(attributes)
    return unless current_disclosure_check.present?

    dimensions = custom_dimensions(
      attributes.delete(:dimensions)
    )

    content_for :transaction_data, {
      id: current_disclosure_check.id,
      sku: transaction_sku,
      quantity: 1,
    }.merge(
      attributes
    ).merge(
      dimensions
    ).to_json.html_safe
  end

  # We try to be as accurate as possible, but some transactions might
  # trigger before having reached the subtype step.
  def transaction_sku
    return 'unknown' if current_disclosure_check.nil?

    current_disclosure_check.conviction_subtype ||
      current_disclosure_check.conviction_type ||
      current_disclosure_check.caution_type ||
      current_disclosure_check.kind
  end

  # This value is used in a GA custom dimension (`spent - dimension1`)
  def ga_spent?(date)
    return 'no_date' unless date.instance_of?(Date)

    date.past? ? 'yes' : 'no'
  end

  private

  # Custom dimensions on Google Analytics are named `dimensionX` where X
  # is an index from 1 to 20 (there is a limit of 20 per GA property).
  # https://support.google.com/analytics/answer/2709828?hl=en
  #
  def custom_dimensions(hash)
    dimensions = hash || {}

    CUSTOM_DIMENSIONS_MAP.each do |key, name|
      dimensions[name] = dimensions.delete(key) if dimensions.key?(key)
    end

    dimensions
  end
end
