class BaseMultiplesCalculator
  attr_reader :check_group

  def initialize(check_group)
    @check_group = check_group
  end

  def kind
    CheckKind.find_constant(disclosure_checks.first.kind)
  end

  # :nocov:
  def spent_date
    raise 'implement in subclasses'
  end
  # :nocov:

  private

  def disclosure_checks
    @_disclosure_checks ||= check_group.disclosure_checks
  end

  def expiry_date_for(check)
    CheckResult.new(disclosure_check: check).expiry_date
  end
end
