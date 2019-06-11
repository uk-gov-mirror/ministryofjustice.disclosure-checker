class CautionResultPresenter
  attr_reader :disclosure_check
  QuestionAnswerRow = Struct.new(:question, :value)

  def initialize(disclosure_check)
    @disclosure_check = disclosure_check
  end

  def summary
    caution_questions.map do |item|
      QuestionAnswerRow.new(item, disclosure_check[item])
    end.compact
  end

  def expiry_date
    CautionExpiryCalculator.new(disclosure_check: disclosure_check).expiry_date
  end

  def caution_questions
    [:kind, :is_date_known, :known_date, :under_age, :caution_type].freeze
  end
end
