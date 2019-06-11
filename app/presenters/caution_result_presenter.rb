class CautionResultPresenter < ResultsPresenter
  def calculator_class
    CautionExpiryCalculator
  end

  def to_partial_path
    'steps/check/results/caution'
  end

  def question_attributes
    [:kind, :is_date_known, :known_date, :under_age, :caution_type].freeze
  end
end
