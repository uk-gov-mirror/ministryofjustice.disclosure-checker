class ExpiryDateCalculator
  attr_reader :disclosure_check, :record

  def initialize(disclosure_check:)
    @disclosure_check = disclosure_check
  end

  def expiry_date
    disclosure_check.caution? ? caution : conviction
  end

  private

  def caution
    disclosure_check.conditional_caution_type? ? conditional_date : caution_result
  end

  def conviction
    # TODO: update when we implement the conviction journey
    raise NotImplementedError
  end

  def caution_result
    return disclosure_check.known_date unless disclosure_check.known_date.nil?

    I18n.t('caution_result')
  end

  def conditional_date
    # TODO: update when we know what to do with a user who did not stick to there condition
    disclosure_check.conditional_end_date
  end
end
