class ConvictionExpiryCalculator
  attr_reader :disclosure_check

  def initialize(disclosure_check:)
    @disclosure_check = disclosure_check
  end

  def expiry_date
    raise NotImplementedError
  end
end
