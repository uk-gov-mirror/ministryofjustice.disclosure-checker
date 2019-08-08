class ConvictionLengthChoices
  SUBTYPES_HIDE_NO_LENGTH_CHOICE ||= [
    ConvictionType::DISMISSAL,
    ConvictionType::SERVICE_DETENTION,
    ConvictionType::DETENTION,
    ConvictionType::DETENTION_TRAINING_ORDER,
  ].freeze

  def self.choices(conviction_subtype:)
    if SUBTYPES_HIDE_NO_LENGTH_CHOICE.include?(conviction_subtype)
      ConvictionLengthType.values - [ConvictionLengthType::NO_LENGTH]
    else
      ConvictionLengthType.values
    end
  end
end
