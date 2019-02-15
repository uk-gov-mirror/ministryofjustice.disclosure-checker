class CheckKind < ValueObject
  VALUES = [
    CAUTION = new(:caution),
    CONVICTION = new(:conviction),
  ].freeze

  def self.values
    VALUES
  end
end
