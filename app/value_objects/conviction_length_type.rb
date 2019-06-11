class ConvictionLengthType < ValueObject
  VALUES = [
    WEEKS = new(:weeks),
    MONTHS = new(:months),
  ].freeze

  def self.values
    VALUES
  end
end
