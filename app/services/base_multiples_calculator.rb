class BaseMultiplesCalculator
  attr_reader :check_group

  def initialize(check_group)
    @check_group = check_group
  end

  def kind
    CheckKind.find_constant(first_disclosure_check.kind)
  end

  def conviction?
    kind.inquiry.conviction?
  end

  def spent?
    return false if spent_date == ResultsVariant::NEVER_SPENT
    return false if spent_date == ResultsVariant::INDEFINITE
    return true  if spent_date == ResultsVariant::SPENT_SIMPLE

    spent_date.past?
  end

  # When there are more than one sentence (checks),
  # all will share the same conviction date.
  def conviction_date
    first_disclosure_check.conviction_date
  end

  # :nocov:
  def spent_date
    raise 'implement in subclasses'
  end
  # :nocov:

  def without_relevant_orders
    (disclosure_checks - relevant_orders)
  end

  private

  def disclosure_checks
    @_disclosure_checks ||= check_group.disclosure_checks
  end

  def first_disclosure_check
    @_first_disclosure_check ||= disclosure_checks.first
  end

  def relevant_orders
    @_relevant_orders ||= disclosure_checks.select(&:relevant_order?)
  end

  def expiry_date_for(check)
    CheckResult.new(disclosure_check: check).expiry_date
  end
end
