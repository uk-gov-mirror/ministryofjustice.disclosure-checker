module Calculators
  class MotoringCalculator < BaseCalculator
    ENDORSEMENT_THRESHOLD = 60
    YOUTH_ENDORSEMENT_THRESHOLD = 30

    # If an endorsement was received
    # start_date + 5 years
    # If an endorsement was not received
    # start_date + 1 year
    # If under age start_date + 6 months
    class MotoringFine < MotoringCalculator
      REHABILITATION_1 = { months: 60 }.freeze
      REHABILITATION_2 = { months: 12 }.freeze
      UNDER_AGE_REHABILITATION_1 = { months: 30 }.freeze
      UNDER_AGE_REHABILITATION_2 = { months: 6 }.freeze

      def expiry_date
        return conviction_start_date.advance(self.class::REHABILITATION_1) if motoring_endorsement? && !under_age?
        return conviction_start_date.advance(self.class::UNDER_AGE_REHABILITATION_1) if motoring_endorsement? && under_age?
        return conviction_start_date.advance(self.class::UNDER_AGE_REHABILITATION_2) if under_age?

        conviction_start_date.advance(self.class::REHABILITATION_2)
      end
    end

    # If an endorsement was received:
    # start_date + 5 years
    # If an endorsement was not received:
    # start_date + 3 years
    class PenaltyPoints < MotoringCalculator
      REHABILITATION_1 = { months: 60 }.freeze
      REHABILITATION_2 = { months: 36 }.freeze
    end

    def expiry_date
      return conviction_start_date.advance(self.class::REHABILITATION_1) if motoring_endorsement?

      conviction_start_date.advance(self.class::REHABILITATION_2)
    end

    def under_age?
      GenericYesNo.new(disclosure_check.under_age).yes?
    end

    def motoring_endorsement?
      GenericYesNo.new(disclosure_check.motoring_endorsement).yes?
    end
  end
end
