class ConvictionResultPresenter < ResultsPresenter
  include ValueObjectMethods

  def to_partial_path
    'results/conviction'
  end

  def custodial_sentence?
    [
      ConvictionType::CUSTODIAL_SENTENCE,
      ConvictionType::ADULT_CUSTODIAL_SENTENCE,
    ].include?(conviction_type)
  end

  private

  def question_attributes
    [
      :kind,
      :conviction_type,
      :conviction_subtype,
      :under_age,
      :known_date,
      [:conviction_length, i18n_conviction_length],
      :compensation_payment_date,
    ].freeze
  end

  def i18n_conviction_length
    type = disclosure_check.conviction_length_type
    return unless type

    I18n.translate!(
      "conviction_length.answers.#{type}",
      length: disclosure_check.conviction_length,
      scope: to_partial_path
    )
  end

  def result_class
    ConvictionCheckResult
  end
end
