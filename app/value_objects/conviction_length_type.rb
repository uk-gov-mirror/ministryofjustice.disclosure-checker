class ConvictionLengthType < ValueObject
  VALUES = [
    WEEKS = new(:weeks),
    MONTHS = new(:months),
    YEARS = new(:years),
    NO_LENGTH = new(:no_length),
  ].freeze

  def self.values
    VALUES
  end
end
