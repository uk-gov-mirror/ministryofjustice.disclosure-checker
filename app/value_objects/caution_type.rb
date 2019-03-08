class CautionType < ValueObject
  VALUES = [
    SIMPLE_CAUTION = new(:simple_caution),
    CONDITIONAL_CAUTION = new(:conditional_caution),
    YOUTH_SIMPLE_CAUTION = new(:youth_simple_caution),
    YOUTH_CONDITIONAL_CAUTION = new(:youth_conditional_caution),
  ].freeze

  def self.values
    VALUES
  end
end
