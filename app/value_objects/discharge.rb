class Discharge < ValueObject
  VALUES = [
    ABSOLUTE_DISCHARGE = new(:absolute_discharge),
    BIND_OVER = new(:bind_over),
    CONDITIONAL_DISCHARGE_ORDER = new(:conditional_discharge_order)
  ].freeze

  def self.values
    VALUES
  end
end
