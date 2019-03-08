class CautionType < ValueObject
  VALUES = [
    YOUTH_VALUES = [
      YOUTH_SIMPLE_CAUTION = new(:youth_simple_caution),
      YOUTH_CONDITIONAL_CAUTION = new(:youth_conditional_caution),
    ].freeze,

    NON_YOUTH_VALUES = [
      SIMPLE_CAUTION = new(:simple_caution),
      CONDITIONAL_CAUTION = new(:conditional_caution),
    ].freeze
  ].flatten.freeze

  def conditional?
    [
      CONDITIONAL_CAUTION,
      YOUTH_CONDITIONAL_CAUTION
  ].include?(self)
  end

  def youth?
    YOUTH_VALUES.include?(self)
  end

  def self.values
    VALUES
  end
end
