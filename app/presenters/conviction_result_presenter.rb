class ConvictionResultPresenter < ResultsPresenter
  def calculator_class
    ConvictionExpiryCalculator
  end

  def to_partial_path
    'steps/check/results/conviction'
  end

  def question_attributes
    [].freeze
  end
end
