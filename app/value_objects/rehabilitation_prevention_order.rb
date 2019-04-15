class RehabilitationPreventionOrder < ValueObject
  VALUES = [
    ATTENDANCE_CENTRE_ORDER = new(:attendance_centre_order),
    DRUG_REHABILITATION = new(:drug_rehabilitation),
    REPARATION_ORDER = new(:reparation_order),
    SEXUAL_HARM_PREVENTION_ORDER = new(:sexual_harm_prevention_order),
    SUPERVISION_ORDER = new(:supervision_order),
    YOUTH_REHABILITATION_ORDER = new(:youth_rehabilitation_order)
  ].freeze

  def self.values
    VALUES
  end
end
