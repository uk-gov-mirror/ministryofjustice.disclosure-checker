class BaseMultiplesCalculator
  attr_reader :check_group

  def initialize(check_group)
    @check_group = check_group
  end

  def kind
    CheckKind.find_constant(disclosure_checks.first.kind)
  end

  def spent?
    return false if spent_date == :never_spent
    return false if spent_date == :indefinite
    return true  if spent_date == :spent_simple

    spent_date.past?
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
