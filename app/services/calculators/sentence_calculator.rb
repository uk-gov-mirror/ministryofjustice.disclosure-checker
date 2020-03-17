module Calculators
  class SentenceCalculator < BaseCalculator
    NEVER_SPENT_THRESHOLD = 48
    BAIL_OFFSET = -1.0

    # If conviction length is 6 months or less: start date + length + 18 months
    # If conviction length is over 6 months and less than or equal to 30 months: start date + length + 2 years
    # If conviction length is over 30 months and less than or equal to 4 years: start date + length + 3.5 years
    # If conviction length is over 4 years: never spent
    #
    class Detention < SentenceCalculator
      UPPER_LIMIT = Float::INFINITY

      REHABILITATION_1 = { months: 18 }.freeze
      REHABILITATION_2 = { months: 24 }.freeze
      REHABILITATION_3 = { months: 42 }.freeze
    end

    # If conviction length is 6 months or less: start date + length + 18 months
    # If conviction length is over 6 months and less than or equal to 24 months: start date + length + 2 years
    # If conviction length is over 24 months, it is considered invalid
    #
    class DetentionTraining < SentenceCalculator
      UPPER_LIMIT = 24

      REHABILITATION_1 = { months: 18 }.freeze
      REHABILITATION_2 = { months: 24 }.freeze
    end

    # If conviction length is 6 months or less: start date + length + 2 years
    # If conviction length is over 6 months and less than or equal to 30 months: start date + length + 4 years
    # If conviction length is over 30 months and less than or equal to 4 years: start date + length + 7 years
    # If conviction length is over 4 years: never spent
    #
    class Prison < SentenceCalculator
      UPPER_LIMIT = Float::INFINITY

      REHABILITATION_1 = { months: 24 }.freeze
      REHABILITATION_2 = { months: 48 }.freeze
      REHABILITATION_3 = { months: 84 }.freeze
    end

    # If conviction length is 6 months or less: start date + length + 2 years
    # If conviction length is over 6 months and less than or equal to 24 months: start date + length + 4 years
    # If conviction length is over 24 months, it is considered invalid
    #
    class SuspendedPrison < SentenceCalculator
      UPPER_LIMIT = 24

      REHABILITATION_1 = { months: 24 }.freeze
      REHABILITATION_2 = { months: 48 }.freeze
    end

    def expiry_date
      raise InvalidCalculation unless valid?

      if conviction_length_in_months > NEVER_SPENT_THRESHOLD
        :never_spent
      else
        conviction_end_date.advance(rehabilitation_period)
      end
    end

    # Used to validate the upper limits, as some convictions can only be given
    # a maximum number of months in the sentence length.
    # We don't take into consideration the bail time here, as this is purely
    # the validation of the raw input of the sentence length.
    #
    def valid?
      conviction_length_in_months(offset_days: 0) <= self.class::UPPER_LIMIT
    end

    private

    def rehabilitation_period
      case conviction_length_in_months
      when 0..6
        self.class::REHABILITATION_1
      when 7..30
        self.class::REHABILITATION_2
      else
        self.class::REHABILITATION_3
      end
    end

    def conviction_length_in_months(offset_days: bail_offset_days)
      sentence_length_in_months(
        disclosure_check.conviction_length,
        disclosure_check.conviction_length_type,
        offset_days: offset_days
      )
    end

    # Each full day spent on bail with a tag offsets the value of `BAIL_OFFSET` from
    # the sentence length. Attribute can be blank or nil, but `#to_i` makes it safe.
    #
    def bail_offset_days
      disclosure_check.conviction_bail_days.to_i * BAIL_OFFSET
    end

    def conviction_end_date
      super.advance(days: -1).advance(days: bail_offset_days)
    end
  end
end
