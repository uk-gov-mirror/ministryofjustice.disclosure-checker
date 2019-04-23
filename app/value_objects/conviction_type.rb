class ConvictionType < ValueObject
  VALUES = [
    COMMUNITY_ORDER = new(:community_order),
    CUSTODIAL_SENTENCE = new(:custodial_sentence),
    DISCHARGE = new(:discharge),
    FINANCIAL = new(:financial),
    HOSPITAL_ORDER = new(:hospital_order),
    MILITARY = new(:military),
    MOTORING = new(:motoring),
    REHABILITATION_PREVENTION_ORDER = new(:rehabilitation_prevention_order)
  ].freeze

  def self.values
    VALUES
  end

  def self.types
    VALUES.map(&:value)
  end
end
