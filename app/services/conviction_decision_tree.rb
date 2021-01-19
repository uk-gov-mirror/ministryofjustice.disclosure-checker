class ConvictionDecisionTree < BaseDecisionTree
  include ValueObjectMethods

  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def destination
    return next_step if next_step

    case step_name
    when :conviction_type
      edit(:conviction_subtype)
    when :conviction_subtype
      after_conviction_subtype
    when :motoring_endorsement
      known_date_question
    when :conviction_bail
      after_conviction_bail
    when :conviction_bail_days
      known_date_question
    when :known_date
      after_known_date
    when :conviction_length_type
      after_conviction_length_type
    when :compensation_paid
      after_compensation_paid
    when :compensation_payment_over_100
      edit(:compensation_payment_date)
    when :compensation_payment_date
      after_compensation_payment_date
    when :compensation_receipt_sent
      after_compensation_receipt_sent
    when :conviction_length, :motoring_disqualification_end_date
      results
    else
      raise InvalidStep, "Invalid step '#{as || step_params}'"
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/CyclomaticComplexity

  private

  def after_conviction_subtype
    return edit(:conviction_bail)    if conviction_subtype.bailable_offense?
    return edit(:compensation_paid)  if conviction_subtype.compensation?
    return after_motoring_conviction if conviction_type.motoring?

    known_date_question
  end

  def after_motoring_conviction
    return edit(:motoring_endorsement) unless conviction_subtype.motoring_penalty_points?

    known_date_question
  end

  def after_known_date
    return results if conviction_subtype.skip_length?
    return edit(:motoring_disqualification_end_date) if conviction_subtype.motoring_disqualification?

    edit(:conviction_length_type)
  end

  def after_conviction_length_type
    return results if ConvictionLengthType.new(step_value(:conviction_length_type)).without_length?

    edit(:conviction_length)
  end

  def after_compensation_paid
    return edit(:compensation_paid_amount) if GenericYesNo.new(disclosure_check.compensation_paid).yes?

    show(:compensation_not_paid)
  end

  def after_compensation_payment_date
    return edit(:compensation_payment_receipt) if GenericYesNo.new(disclosure_check.compensation_payment_over_100).yes?

    results
  end

  def after_compensation_receipt_sent
    return show(:compensation_unable_to_tell) if GenericYesNo.new(disclosure_check.compensation_receipt_sent).no?

    results
  end

  def after_conviction_bail
    return edit(:conviction_bail_days) if step_value(:conviction_bail).inquiry.yes?

    known_date_question
  end

  def known_date_question
    edit(:known_date)
  end
end
