class CheckGroupPresenter
  attr_reader :number, :check_group, :spent_date, :scope

  def initialize(number, check_group, spent_date:, scope:, results_page: false)
    @number = number
    @check_group = check_group
    @spent_date = spent_date
    @scope = scope
    @results_page = results_page
  end

  def summary
    sentences = completed_checks.size

    completed_checks.map.with_index(1) do |disclosure_check, i|
      CheckPresenter.new(disclosure_check, number: i, sentences: sentences, results_page: @results_page)
    end
  end

  def spent_date_panel
    SpentDatePanel.new(
      spent_date: spent_date,
      kind: first_check_kind
    )
  end

  def to_partial_path
    if @results_page
      'results/multiples/check'
    else
      'check_your_answers/shared/check'
    end
  end

  def add_another_sentence_button?
    check_group.disclosure_report.in_progress? &&
      first_check_kind.inquiry.conviction?
  end

  def check_group_name
    first_check_kind
  end

  private

  def first_check_kind
    @_first_check_kind ||= completed_checks.first.kind
  end

  def completed_checks
    @_completed_checks ||= check_group.disclosure_checks.completed
  end
end
