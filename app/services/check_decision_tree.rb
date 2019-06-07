class CheckDecisionTree < BaseDecisionTree
  def destination
    return next_step if next_step

    case step_name
    when :kind
      after_kind_step
    else
      raise InvalidStep, "Invalid step '#{as || step_params}'"
    end
  end

  private

  def after_kind_step
    case CheckKind.new(step_params[:kind])
    when CheckKind::CAUTION
      edit('/steps/caution/under_age')
    when CheckKind::CONVICTION
      edit('/steps/conviction/under_age')
    end
  end
end
