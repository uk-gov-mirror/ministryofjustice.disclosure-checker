class CheckAnswersPresenter
  attr_reader :disclosure_report

  def initialize(disclosure_report)
    @disclosure_report = disclosure_report
  end

  def summary
    calculator.proceedings.map.with_index(1) do |proceeding, i|
      CheckGroupPresenter.new(
        i,
        proceeding.check_group,
        spent_date: calculator.spent_date_for(proceeding),
        scope: to_partial_path
      )
    end
  end

  def calculator
    @_calculator ||= Calculators::Multiples::MultipleOffensesCalculator.new(disclosure_report)
  end

  # This is how many cautions or convictions are in this report, meaning
  # 1 caution and 1 conviction with 3 sentences will return 2.
  def proceedings_size
    calculator.proceedings.size
  end

  # This is how many individual "checks" are in this report, meaning
  # 1 caution and 1 conviction with 3 sentences will return 4.
  def orders_size
    calculator.proceedings.sum(&:size)
  end

  def variant
    :multiples
  end

  def to_partial_path
    'check_your_answers/check'
  end
end
