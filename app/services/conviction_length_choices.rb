class ConvictionLengthChoices
  SUBTYPES_HIDE_NO_LENGTH_CHOICE ||= [
    ConvictionType::DETENTION,
    ConvictionType::DETENTION_TRAINING_ORDER,
    ConvictionType::ADULT_PRISON_SENTENCE,
    ConvictionType::ADULT_SUSPENDED_PRISON_SENTENCE,
    ConvictionType::ADULT_ATTENDANCE_CENTRE_ORDER,
    ConvictionType::ADULT_SERIOUS_CRIME_PREVENTION,
  ].freeze

  def self.choices(conviction_subtype:)
    if SUBTYPES_HIDE_NO_LENGTH_CHOICE.include?(conviction_subtype)
      ConvictionLengthType.values - [ConvictionLengthType::NO_LENGTH]
    else
      ConvictionLengthType.values
    end
  end
end
