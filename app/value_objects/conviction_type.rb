class ConvictionType < ValueObject
  attr_reader :parent, :skip_length, :compensation

  def initialize(raw_value, params = {})
    @parent = params.fetch(:parent, nil)
    @skip_length = params.fetch(:skip_length, false)
    @compensation = params.fetch(:compensation, false)

    super(raw_value)
  end

  def self.find_constant(raw_value)
    const_get(raw_value.upcase)
  end

  alias skip_length? skip_length
  alias compensation? compensation

  VALUES = [
    PARENT_TYPES = [
      COMMUNITY_ORDER       = new(:community_order),
      CUSTODIAL_SENTENCE    = new(:custodial_sentence),
      DISCHARGE             = new(:discharge),
      FINANCIAL             = new(:financial),
      HOSPITAL_GUARD_ORDER  = new(:hospital_guard_order),
    ].freeze,

    ALCOHOL_ABSTINENCE_TREATMENT       = new(:alcohol_abstinence_treatment,     parent: COMMUNITY_ORDER),
    ATTENDANCE_CENTRE_ORDER            = new(:attendance_centre_order,          parent: COMMUNITY_ORDER),
    BEHAVIOURAL_CHANGE_PROG            = new(:behavioural_change_prog,          parent: COMMUNITY_ORDER),
    CURFEW                             = new(:curfew,                           parent: COMMUNITY_ORDER),
    DRUG_REHABILITATION                = new(:drug_rehabilitation,              parent: COMMUNITY_ORDER),
    EXCLUSION_REQUIREMENT              = new(:exclusion_requirement,            parent: COMMUNITY_ORDER),
    INTOXICATING_SUBSTANCE_TREATMENT   = new(:intoxicating_substance_treatment, parent: COMMUNITY_ORDER),
    MENTAL_HEALTH_TREATMENT            = new(:mental_health_treatment,          parent: COMMUNITY_ORDER),
    PROHIBITION                        = new(:prohibition,                      parent: COMMUNITY_ORDER),
    REFERRAL_ORDER                     = new(:referral_order,                   parent: COMMUNITY_ORDER),
    REHAB_ACTIVITY_REQUIREMENT         = new(:rehab_activity_requirement,       parent: COMMUNITY_ORDER),
    REPARATION_ORDER                   = new(:reparation_order,                 parent: COMMUNITY_ORDER),
    RESIDENCE_REQUIREMENT              = new(:residence_requirement,            parent: COMMUNITY_ORDER),
    SEXUAL_HARM_PREVENTION_ORDER       = new(:sexual_harm_prevention_order,     parent: COMMUNITY_ORDER),
    SUPER_ORD_BREACH_CIVIL_INJUC       = new(:super_ord_breach_civil_injuc,     parent: COMMUNITY_ORDER),
    UNPAID_WORK                        = new(:unpaid_work,                      parent: COMMUNITY_ORDER),
    DETENTION_TRAINING_ORDER           = new(:detention_training_order,         parent: CUSTODIAL_SENTENCE),
    DETENTION                          = new(:detention,                        parent: CUSTODIAL_SENTENCE),

    ABSOLUTE_DISCHARGE                 = new(:absolute_discharge,               parent: DISCHARGE, skip_length: true),
    CONDITIONAL_DISCHARGE              = new(:conditional_discharge,            parent: DISCHARGE),

    FINE                               = new(:fine,                             parent: FINANCIAL, skip_length: true),
    COMPENSATION_TO_A_VICTIM           = new(:compensation_to_a_victim,         parent: FINANCIAL, compensation: true),

    HOSPITAL_ORDER                     = new(:hospital_order,                   parent: HOSPITAL_GUARD_ORDER),
    GUARDIANSHIP_ORDER                 = new(:guardianship_order,               parent: HOSPITAL_GUARD_ORDER),
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
