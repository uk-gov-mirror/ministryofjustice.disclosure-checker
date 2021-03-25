class CheckAnswersPresenter
  attr_reader :disclosure_report

  def initialize(disclosure_report, show_spent_date_panel: false)
    @disclosure_report = disclosure_report
    @show_spent_date_panel = show_spent_date_panel
  end

  def summary
    calculator.proceedings.map.with_index(1) do |proceeding, i|
      CheckGroupPresenter.new(
        i,
        proceeding.check_group,
        spent_date: calculator.spent_date_for(proceeding),
        scope: to_partial_path,
        show_spent_date_panel: @show_spent_date_panel
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
