class Financial < ValueObject
  VALUES = [
    FINE = new(:fine),
    COMPENSATION_TO_A_VICTIM = new(:compensation_to_a_victim)
  ].freeze

  def self.values
    VALUES
  end
end
