class ResultsPresenter
  attr_reader :disclosure_check

  def self.build(disclosure_check)
    case CheckKind.new(disclosure_check.kind)
    when CheckKind::CAUTION
      CautionResultPresenter.new(disclosure_check)
    when CheckKind::CONVICTION
      ConvictionResultPresenter.new(disclosure_check)
    else
      raise TypeError, 'unknown check kind'
    end
  end

  def initialize(disclosure_check)
    @disclosure_check = disclosure_check
  end

  def summary
    question_attributes.map do |item|
      QuestionAnswerRow.new(item, disclosure_check[item], scope: to_partial_path)
    end.select(&:show?)
  end

  def expiry_date
    calculator.expiry_date
  end

  private

  def calculator
    @_calculator ||= calculator_class.new(
      disclosure_check: disclosure_check
    )
  end

  # :nocov:
  def calculator_class
    raise NotImplementedError, 'implement in subclasses'
  end

  def to_partial_path
    raise NotImplementedError, 'implement in subclasses'
  end

  def question_attributes
    raise NotImplementedError, 'implement in subclasses'
  end
  # :nocov:
end