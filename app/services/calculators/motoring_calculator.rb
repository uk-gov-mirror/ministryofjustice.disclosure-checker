module Calculators
  class MotoringCalculator < BaseCalculator
    ENDORSEMENT_THRESHOLD = 60
    YOUTH_ENDORSEMENT_THRESHOLD = 30

    # If a lifetime ban was given:
    #  - never spent
    # If no end_date was given: Start date + 5 years
    #  - Start date + 5 years
    # If an endorsement was received
    #  - If (end_date - start_date) is less than or equal to 5 years: start_date + 5 years
    #  - If (end_date - start_date) is greater than 5 years: end_date

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
        return :never_spent if GenericYesNo.new(disclosure_check.motoring_lifetime_ban).yes?
        return conviction_start_date.advance(missing_end_date_spent_time) if motoring_disqualification_end_date.nil?

        spent_time
      end

      private

      def spent_time
        return conviction_start_date.advance(TWO_AND_HALF_YEARS_ADDED_TIME) if (under_age? && motoring_endorsement?) && within_endorsement_threshold?
        return conviction_start_date.advance(FIVE_YEARS_ADDED_TIME) if motoring_endorsement? && within_endorsement_threshold?

        motoring_disqualification_end_date
      end

      def missing_end_date_spent_time
        return FIVE_YEARS_ADDED_TIME if motoring_endorsement?

        TWO_YEARS_ADDED_TIME
      end

      def motoring_disqualification_end_date
        @motoring_disqualification_end_date ||= disclosure_check.motoring_disqualification_end_date
      end

      def within_endorsement_threshold?
        distance_in_months(conviction_start_date, motoring_disqualification_end_date) <= ENDORSEMENT_THRESHOLD
      end
    end

    # If an endorsement was received
    # start_date + 5 years

    # If an endorsement was not received
    # Go to different result page: https://moj-disclosure-checker.herokuapp.com/motoring/v3/fpn-no-conviction
    class PenaltyNotice < MotoringCalculator
      REHABILITATION_1 = { months: 60 }.freeze
      TWO_AND_HALF_YEARS_ADDED_TIME = { months: 30 }.freeze

      def expiry_date
        return conviction_start_date.advance(TWO_AND_HALF_YEARS_ADDED_TIME) if (under_age? && motoring_endorsement?)
        return conviction_start_date.advance(REHABILITATION_1) if motoring_endorsement?

        :no_record
      end
    end

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
      return conviction_start_date.advance(self.class::REHABILITATION_1) if motoring_endorsement? && !under_age?

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
