class CheckPresenter
  attr_reader :disclosure_check, :number

  def initialize(disclosure_check, number:, sentences:, results_page: false)
    @disclosure_check = disclosure_check
    @results_page = results_page
    @number = number
    @sentences = sentences
  end

  def show_sentence_header?
    @sentences > 1
  end

  def summary
    CheckRow.new(
      ResultsPresenter.build(disclosure_check).summary,
      scope: to_partial_path,
      results_page: @results_page
    )
  end

  def to_partial_path
    if @results_page
      'results/multiples/check_row'
    else
      'check_your_answers/shared/check_row'
    end
  end
end
