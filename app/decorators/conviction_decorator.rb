module ConvictionDecorator
  def compensation?
    [
      ConvictionType::COMPENSATION_TO_A_VICTIM,
      ConvictionType::ADULT_COMPENSATION_TO_A_VICTIM,
    ].include?(self)
  end

  def custodial_sentence?
    [
      ConvictionType::CUSTODIAL_SENTENCE,
      ConvictionType::ADULT_CUSTODIAL_SENTENCE,
    ].include?(self)
  end

  def motoring?
    ConvictionType::YOUTH_MOTORING.eql?(self) ||
      ConvictionType::ADULT_MOTORING.eql?(self)
  end

  def motoring_disqualification?
    ConvictionType::YOUTH_DISQUALIFICATION.eql?(self) ||
      ConvictionType::ADULT_DISQUALIFICATION.eql?(self)
  end

  def motoring_penalty_notice?
    ConvictionType::YOUTH_PENALTY_NOTICE.eql?(self) ||
      ConvictionType::ADULT_PENALTY_NOTICE.eql?(self)
  end

  def bailable_offense?
    [
      ConvictionType::DETENTION,
      ConvictionType::DETENTION_TRAINING_ORDER,
      ConvictionType::ADULT_PRISON_SENTENCE,
      ConvictionType::ADULT_SUSPENDED_PRISON_SENTENCE,
    ].include?(self)
  end
end
