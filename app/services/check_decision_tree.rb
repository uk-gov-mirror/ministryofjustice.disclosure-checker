class CheckDecisionTree < BaseDecisionTree
  def destination
    return next_step if next_step

    case step_name
    when :kind
      edit(:under_age)
    when :under_age
      after_under_age
    when :add_caution_or_conviction
      after_add_caution_or_conviction
    else
      raise InvalidStep, "Invalid step '#{as || step_params}'"
    end
  end

  private

  def after_under_age
    case CheckKind.new(disclosure_check.kind)
    when CheckKind::CAUTION
      edit('/steps/caution/caution_type')
    when CheckKind::CONVICTION
      return edit('/steps/conviction/conviction_date') if multiples_enabled?

      edit('/steps/conviction/conviction_type')
    end
  end

  def after_add_caution_or_conviction
    return show(:results, show_results: true) if GenericYesNo.new(step_params[:add_caution_or_conviction]).no?

    controller.send(
      :initialize_disclosure_check,
      disclosure_report: disclosure_check.disclosure_report
    )

    edit(:kind)
  end
end
