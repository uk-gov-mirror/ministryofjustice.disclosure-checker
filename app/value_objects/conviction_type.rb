class ConvictionType < ValueObject
  attr_reader :parent

  def initialize(raw_value, params = {})
    @parent = params.fetch(:parent, nil)
    super(raw_value)
  end

  VALUES = [
    PARENT_TYPES = [
      COMMUNITY_ORDER    = new(:community_order),
      CUSTODIAL_SENTENCE = new(:custodial_sentence),
      DISCHARGE          = new(:discharge),
      FINANCIAL          = new(:financial),
      HOSPITAL_ORDER     = new(:hospital_order),
      MILITARY           = new(:military),
      MOTORING           = new(:motoring),
      REHAB_PREV_ORDER   = new(:rehab_prev_order),
    ].freeze,

    ALCOHOL_ABSTINENCE         = new(:alcohol_abstinence,         parent: COMMUNITY_ORDER),
    ALCOHOL_TREATMENT          = new(:alcohol_treatment,          parent: COMMUNITY_ORDER),
    BEHAVIOURAL_CHANGE_PROG    = new(:behavioural_change_prog,    parent: COMMUNITY_ORDER),
    CURFEW                     = new(:curfew,                     parent: COMMUNITY_ORDER),
    DRUG_REHABILITATION        = new(:drug_rehabilitation,        parent: COMMUNITY_ORDER),
    EXCLUSION_REQUIREMENT      = new(:exclusion_requirement,      parent: COMMUNITY_ORDER),
    FOREIGN_TRAVEL_PROHIBITION = new(:foreign_travel_prohibition, parent: COMMUNITY_ORDER),
    MENTAL_HEALTH_TREATMENT    = new(:mental_health_treatment,    parent: COMMUNITY_ORDER),
    PROHIBITION                = new(:prohibition,                parent: COMMUNITY_ORDER),
    REFERRAL_ORDER             = new(:referral_order,             parent: COMMUNITY_ORDER),
    REHAB_ACTIVITY_REQUIREMENT = new(:rehab_activity_requirement, parent: COMMUNITY_ORDER),
    RESIDENCE_REQUIREMENT      = new(:residence_requirement,      parent: COMMUNITY_ORDER),
    UNPAID_WORK                = new(:unpaid_work,                parent: COMMUNITY_ORDER),
  ].flatten.freeze

  # :nocov:
  def self.values
    VALUES
  end
  # :nocov:

  def children
    VALUES.select { |value| value.parent.eql?(self) }
  end
end
