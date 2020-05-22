module Calculators
  class MotoringCalculator < BaseCalculator
    ADULT_ENDORSEMENT_THRESHOLD = 60
    YOUTH_ENDORSEMENT_THRESHOLD = 30

    def motoring_endorsement?
      GenericYesNo.new(disclosure_check.motoring_endorsement).yes?
    end
  end
end
