class ConvictionType < ValueObject
  VALUES = [
    COMMUNITY_SENTENCE = new(:community_sentence),
    CUSTODIAL_SENTENCE = new(:custodial_sentence),
    DISCHARGE = new(:discharge),
    FINANCIAL = new(:financial),
    HOSPITAL_ORDER = new(:hospital_order),
    MILITARY = new(:military),
    MOTORING = new(:motoring),
    REHABILITATION_OR_PREVENTION = new(:rehabilitation_or_prevention)
  ].freeze

  def self.values
    VALUES
  end
end
