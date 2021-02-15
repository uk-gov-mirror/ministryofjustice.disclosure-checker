class ConvictionLengthChoices
  SUBTYPES_HIDE_NO_LENGTH_CHOICE = [
    ConvictionType::DETENTION,
    ConvictionType::DETENTION_TRAINING_ORDER,
    ConvictionType::ADULT_PRISON_SENTENCE,
    ConvictionType::ADULT_SUSPENDED_PRISON_SENTENCE,
    ConvictionType::ADULT_ATTENDANCE_CENTRE_ORDER,
  ].freeze

  def self.choices(conviction_subtype:)
    choices = ConvictionLengthType.values.dup

    # Only `relevant orders` will show the `indefinite` length option
    choices.delete(ConvictionLengthType::INDEFINITE) unless conviction_subtype.relevant_order?

    # Big majority of orders show the `no_length` option, just a few exceptions
    choices.delete(ConvictionLengthType::NO_LENGTH) if SUBTYPES_HIDE_NO_LENGTH_CHOICE.include?(conviction_subtype)

    choices
  end
end
