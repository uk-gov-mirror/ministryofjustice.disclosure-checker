class CautionDecisionTree < BaseDecisionTree
  def destination
    return next_step if next_step

    case step_name
    when :caution_date
      # TODO: change when we have next step
      { controller: '/home', action: :index }
    else
      raise InvalidStep, "Invalid step '#{as || step_params}'"
    end
  end
end
