class CautionResultPresenter
  attr_reader :disclosure_check
  QuestionAnswerRow = Struct.new(:question, :value)

  def initialize(disclosure_check)
    @disclosure_check = disclosure_check
  end

  def summary
    caution_questions.map do |item|
      next if disclosure_check[item].nil?

      QuestionAnswerRow.new(item, disclosure_check[item])
    end
  end

  def expiry_date
    ExpiryDateCalculator.new(disclosure_check: disclosure_check).expiry_date
  end

  def caution_questions
    [:kind, :caution_date, :under_age, :caution_date].freeze
  end
end
