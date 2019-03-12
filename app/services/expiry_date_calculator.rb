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
    disclosure_check.conditional_caution_type? ? conditional_date : disclosure_check.caution_date
  end

  def conviction
    # TODO: update when we implement the conviction journey
    raise NotImplementedError
  end

  def conditional_date
    # TODO: update when we implement caution with conditional journey
    raise NotImplementedError
  end
end
