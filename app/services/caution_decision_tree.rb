class CautionDecisionTree < BaseDecisionTree
  # rubocop:disable Metrics/CyclomaticComplexity
  def destination
    return next_step if next_step

    case step_name
    when :caution_date
      edit(:under_age)
    when :under_age
      edit(:caution_type)
    when :caution_type
      after_caution_type
    when :conditional_end_date
      edit(:condition_complied)
    when :condition_complied
      after_condition_complied
    else
      raise InvalidStep, "Invalid step '#{as || step_params}'"
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  private

  def after_caution_type
    return edit(:conditional_end_date) if CautionType.new(disclosure_check.caution_type).conditional?

    result
  end

  def after_condition_complied
    return result if GenericYesNo.new(disclosure_check.condition_complied).yes?

    show(:condition_exit)
  end

  def result
    show(:result)
  end
end
