class CheckResult
  include ValueObjectMethods
  attr_reader :disclosure_check

  def initialize(disclosure_check:)
    @disclosure_check = disclosure_check
  end

  def expiry_date
    calculator.expiry_date
  end

  def calculator
    offence_type.calculator_class.new(disclosure_check)
  end
end
