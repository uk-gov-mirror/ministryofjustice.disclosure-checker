class CautionResultPresenter < ResultsPresenter
  def to_partial_path
    'results/caution'
  end

  def question_attributes
    [
      :kind,
      :caution_type,
      :under_age,
      :known_date,
      :conditional_end_date,
    ].freeze
  end

  private

  def result_class
    CautionCheckResult
  end
end
