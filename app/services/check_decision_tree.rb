class CheckDecisionTree < BaseDecisionTree
  def destination
    return next_step if next_step

    case step_name
    # TODO: Put decision logic here
    when :kind
      edit(:caution_date)
    when :caution_date
      '/'
    else
      raise InvalidStep, "Invalid step '#{as || step_params}'"
    end
  end
end
