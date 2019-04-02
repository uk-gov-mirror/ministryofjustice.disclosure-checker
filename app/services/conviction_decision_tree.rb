class ConvictionDecisionTree < BaseDecisionTree
  def destination
    return next_step if next_step

    case step_name
    when :known_conviction_date
      after_known_conviction_date
    when :under_age_conviction
      show(:exit)
    when :exit
      show(:exit)
    else
      raise InvalidStep, "Invalid step '#{as || step_params}'"
    end
  end

  private

  def after_known_conviction_date
    return show(:exit) if GenericYesNo.new(disclosure_check.known_conviction_date).yes?

    edit(:under_age_conviction)
  end
end
