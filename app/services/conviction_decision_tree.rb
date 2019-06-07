class ConvictionDecisionTree < BaseDecisionTree
  # rubocop:disable Metrics/CyclomaticComplexity
  def destination
    return next_step if next_step

    case step_name
    when :under_age
      after_under_age
    when :conviction_type
      after_conviction_type
    when :conviction_subtype
      edit(:conviction_end_date)
    when :conviction_end_date
      show(:exit)
    when :exit
      show(:exit)
    else
      raise InvalidStep, "Invalid step '#{as || step_params}'"
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  private

  def after_under_age
    return edit(:conviction_type) if GenericYesNo.new(disclosure_check.under_age).yes?

    show(:exit)
  end

  def after_conviction_type
    return edit(:conviction_subtype) if conviction.children.any?

    edit(:conviction_end_date)
  end

  def conviction
    Conviction.new(step_value(:conviction_type))
  end
end
