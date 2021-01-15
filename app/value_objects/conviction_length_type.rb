class ConvictionLengthType < ValueObject
  VALUES = [
    WEEKS = new(:weeks),
    MONTHS = new(:months),
    YEARS = new(:years),
    NO_LENGTH = new(:no_length),
    INDEFINITE = new(:indefinite),
  ].freeze

  def without_length?
    [NO_LENGTH, INDEFINITE].include?(self)
  end

  def self.values
    VALUES
  end
end
