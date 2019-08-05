class CautionDecisionTree < BaseDecisionTree
  # rubocop:disable Metrics/CyclomaticComplexity
  def destination
    return next_step if next_step

    case step_name
    when :under_age, :bypass_under_age
      after_under_age
    when :caution_type
      edit(:known_date)
    when :known_date
      after_known_date
    when :conditional_end_date
      result
    else
      raise InvalidStep, "Invalid step '#{as || step_params}'"
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  private

  def after_under_age
    return edit(:caution_type) if under_age_or_bypass?

    show('/steps/check/exit_over18')
  end

  def after_known_date
    return edit(:conditional_end_date) if CautionType.new(disclosure_check.caution_type).conditional?

    result
  end

  def result
    show('/steps/check/results')
  end
end
