class CheckRow
  attr_reader :question_answers, :scope

  def initialize(question_answers, scope:, results_page: false)
    @question_answers = question_answers
    @scope = scope
    @results_page = results_page
  end

  def to_partial_path
    if @results_page
      'results/multiples/check_row'
    else
      'check_your_answers/shared/check_row'
    end
  end
end
