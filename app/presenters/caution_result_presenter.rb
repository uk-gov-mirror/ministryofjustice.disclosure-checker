class CautionResultPresenter < ResultsPresenter
  def to_partial_path
    'results/caution'
  end

  def question_attributes
    [:kind, :is_date_known, :known_date, :under_age, :caution_type].freeze
  end

  private

  def calculator_class
    CautionExpiryCalculator
  end
end
