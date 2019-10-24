class BaseMultiplesCalculator
  attr_reader :check_group

  def initialize(check_group)
    @check_group = check_group
  end

  # :nocov:
  def spent_date
    raise 'implement in subclasses'
  end
  # :nocov:

  private

  def expiry_date_for(check)
    CheckResult.new(disclosure_check: check).expiry_date
  end
end
