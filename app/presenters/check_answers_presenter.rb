class CheckAnswersPresenter
  attr_reader :disclosure_report

  def initialize(disclosure_report)
    @disclosure_report = disclosure_report

    calculator.process! if disclosure_report.completed?
  end

  def summary
    disclosure_report.check_groups.with_completed_checks.map.with_index(1) do |check_group, i|
      CheckGroupPresenter.new(
        i,
        check_group,
        spent_date: calculator.spent_date_for(check_group), # will be `nil` if no date found
        scope: to_partial_path
      )
    end
  end

  def calculator
    @_calculator ||= Calculators::Multiples::MultipleOffensesCalculator.new(disclosure_report)
  end

  def variant
    :multiples
  end

  def to_partial_path
    'check_your_answers/check'
  end
end
