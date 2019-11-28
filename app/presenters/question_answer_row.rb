class QuestionAnswerRow
  attr_reader :question, :answer, :scope

  def initialize(question, answer, scope:)
    @question = question
    @answer = answer
    @scope = scope
  end

  def show?
    answer.present?
  end

  def to_partial_path
    'results/shared/row'
  end
end
