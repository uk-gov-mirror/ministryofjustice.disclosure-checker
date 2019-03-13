class ConvictionDecisionTree < BaseDecisionTree
  def destination
    return next_step if next_step

    case step_name
    when :exit
      show(:exit)
    else
      raise InvalidStep, "Invalid step '#{as || step_params}'"
    end
  end
end
