module Calculators
  module Motoring
    module Youth
      # If no end_date was given:
      #  - Start date + 2 years
      # If an endorsement was received
      #  - If (end_date - start_date) is less than or equal to 2.5 years: start_date + 2.5 years
      #  - If (end_date - start_date) is greater than 2.5 years: end_date

      # If an endorsement was not received
      # If no end_date was given:
      #  - Start date + 2 years
      # with an End date
      #  - End date
      class Disqualification < MotoringCalculator
        FIVE_YEARS_ADDED_TIME = { months: 60 }.freeze
        TWO_AND_HALF_YEARS_ADDED_TIME = { months: 30 }.freeze
        TWO_YEARS_ADDED_TIME = { months: 24 }.freeze

        def expiry_date
          return conviction_start_date.advance(missing_end_date_spent_time) if motoring_disqualification_end_date.nil?

          spent_time
        end

        private

        def spent_time
          return conviction_start_date.advance(TWO_AND_HALF_YEARS_ADDED_TIME) if motoring_endorsement? && within_endorsement_threshold?

          motoring_disqualification_end_date
        end

        def missing_end_date_spent_time
          return TWO_AND_HALF_YEARS_ADDED_TIME if motoring_endorsement?

          TWO_YEARS_ADDED_TIME
        end

        def motoring_disqualification_end_date
          @motoring_disqualification_end_date ||= disclosure_check.motoring_disqualification_end_date
        end

        def within_endorsement_threshold?
          distance_in_months(conviction_start_date, motoring_disqualification_end_date) <= YOUTH_ENDORSEMENT_THRESHOLD
        end
      end
    end
  end
end
