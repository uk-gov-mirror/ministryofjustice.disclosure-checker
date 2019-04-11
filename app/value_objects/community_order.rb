class CommunityOrder < ValueObject
  VALUES = [
    ALCOHOL_ABSTINENCE = new(:alcohol_abstinence),
    ALCOHOL_TREATMENT = new(:alcohol_treatment),
    BEHAVIOURAL_CHANGE_PROGRAMME = new(:behavioural_change_programme),
    CURFEW = new(:curfew),
    DRUG_REHABILITATION = new(:drug_rehabilitation),
    EXCLUSION_REQUIREMENT = new(:exclusion_requirement),
    FOREIGN_TRAVEL_PROHIBITION = new(:foreign_travel_prohibition),
    MENTAL_HEALTH_TREATMENT = new(:mental_health_treatment),
    PROHIBITION = new(:prohibition),
    REFERRAL_ORDER = new(:referral_order),
    REHABILITATION_ACTIVITY_REQUIREMENT = new(:rehabilitation_activity_requirement),
    RESIDENCE_REQUIREMENT = new(:residence_requirement),
    UNPAID_WORK = new(:unpaid_work)
  ].freeze

  def self.values
    VALUES
  end
end
