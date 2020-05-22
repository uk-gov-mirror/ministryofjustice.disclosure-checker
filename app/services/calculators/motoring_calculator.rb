module Calculators
  class MotoringCalculator < BaseCalculator
    ENDORSEMENT_THRESHOLD = 60
    YOUTH_ENDORSEMENT_THRESHOLD = 30

    def under_age?
      GenericYesNo.new(disclosure_check.under_age).yes?
    end

    def motoring_endorsement?
      GenericYesNo.new(disclosure_check.motoring_endorsement).yes?
    end
  end
end
