module Calculators
  class DisqualificationCalculator < BaseCalculator
    class Youths < DisqualificationCalculator
      #
      # If an endorsement was received:
      #
      #   - If length is less than or equal to 2.5 years (30 months): start date + 30 months
      #   - If length is greater than 2.5 years (30 months): start date + length
      #   - If no length was given: start date + 30 months
      #   - If an indefinite ban was given: until further order
      #
      # If an endorsement was not received:
      #
      #   - If length was given: start date + length
      #   - If no length was given: start date + 24 months
      #   - If an indefinite ban was given: until further order
      #
      ENDORSEMENT_THRESHOLD = 30

      REHABILITATION_WITH_ENDORSEMENT = { months: 30 }.freeze
      REHABILITATION_WITHOUT_ENDORSEMENT = { months: 24 }.freeze
    end

    class Adults < DisqualificationCalculator
      #
      # If an endorsement was received:
      #
      #   - If length is less than or equal to 5 years (60 months): start date + 60 months
      #   - If length is greater than 5 years (60 months): start date + length
      #   - If no length was given: start date + 60 months
      #   - If an indefinite ban was given: until further order
      #
      # If an endorsement was not received:
      #
      #   - If length was given: start date + length
      #   - If no length was given: start date + 24 months
      #   - If an indefinite ban was given: until further order
      #
      ENDORSEMENT_THRESHOLD = 60

      REHABILITATION_WITH_ENDORSEMENT = { months: 60 }.freeze
      REHABILITATION_WITHOUT_ENDORSEMENT = { months: 24 }.freeze
    end

    def expiry_date
      return ResultsVariant::INDEFINITE if indefinite_length?

      if disclosure_check.conviction_length?
        conviction_start_date.advance(rehabilitation_with_length)
      else
        conviction_start_date.advance(rehabilitation_without_length)
      end
    end

    private

    def rehabilitation_without_length
      return self.class::REHABILITATION_WITH_ENDORSEMENT if motoring_endorsement?

      self.class::REHABILITATION_WITHOUT_ENDORSEMENT
    end

    def rehabilitation_with_length
      return self.class::REHABILITATION_WITH_ENDORSEMENT if motoring_endorsement? && within_endorsement_threshold?

      conviction_length
    end

    def within_endorsement_threshold?
      conviction_length_in_months <= self.class::ENDORSEMENT_THRESHOLD
    end
  end
end
