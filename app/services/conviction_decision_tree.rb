class ConvictionDecisionTree < BaseDecisionTree
  # rubocop:disable Metrics/CyclomaticComplexity
  def destination
    return next_step if next_step

    case step_name
    when :known_conviction_date
      after_known_conviction_date
    when :under_age_conviction
      edit(:conviction_type)
    when :known_date
      edit(:under_age_conviction)
    when :conviction_type
      after_conviction_type
    when conviction_type?(step_name)
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

  def after_known_conviction_date
    return edit(:known_date) if GenericYesNo.new(disclosure_check.known_conviction_date).yes?

    edit(:under_age_conviction)
  end

  def after_conviction_type
    return edit(:conviction_end_date) if selected?(:conviction_type, value: 'hospital_order')
    return edit(step_value(:conviction_type).to_sym) if ConvictionType.types.include?(step_value(:conviction_type).to_sym)

    show(:exit)
  end

  def conviction_type?(type)
    return type if ConvictionType.types.include?(type)
  end
end
