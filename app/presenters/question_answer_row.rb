class QuestionAnswerRow
  attr_reader :question, :answer, :scope

  def initialize(question, answer, scope:)
    @question = question
    @answer = format_answer(answer)
    @scope = scope
  end

  def show?
    answer.present?
  end

  def to_partial_path
    'results/shared/row'
  end

  private

  def format_answer(value)
    value.is_a?(Date) ? I18n.l(value) : value
  end
end
