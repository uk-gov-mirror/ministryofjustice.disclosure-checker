class CheckGroupPresenter
  attr_reader :number, :check_group, :spent_date, :scope, :show_spent_date_panel

  alias show_spent_date_panel? show_spent_date_panel

  def initialize(number, check_group, spent_date:, scope:, show_spent_date_panel:)
    @number = number
    @check_group = check_group
    @spent_date = spent_date
    @scope = scope
    @show_spent_date_panel = show_spent_date_panel
  end

  def summary
    completed_checks.map do |disclosure_check|
      CheckPresenter.new(disclosure_check)
    end
  end

  def spent_date_panel
    SpentDatePanel.new(
      spent_date: spent_date,
      kind: first_check_kind
    )
  end

  def to_partial_path
    'check_your_answers/shared/check'
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
