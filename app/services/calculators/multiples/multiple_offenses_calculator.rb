module Calculators
  module Multiples
    class MultipleOffensesCalculator
      attr_reader :disclosure_report,
                  :results

      def initialize(disclosure_report)
        @disclosure_report = disclosure_report
        @results = {}

        process!
      end

      # The order returned in this collection is the order in which
      # the user entered their cautions and/or convictions.
      def proceedings
        @_proceedings ||= results.values
      end

      def spent_date_for(proceeding)
        return unless disclosure_report.completed?

        conviction_date = proceeding.conviction_date
        spent_date = proceeding.spent_date

        # Cautions are always dealt with separately and do not have drag-through
        return spent_date unless proceeding.conviction?

        # We have to loop through the other convictions and check if the spent date
        # of this conviction overlaps with the rehabilitation of another one and if so,
        # then the spent date of this conviction becomes the spent date of the other.
        #
        # One important rule:
        #
        #   Assuming there are overlaps, everything that has an end date given before a
        #   "never spent" conviction becomes "never spent". Everything afterwards is not
        #   affected by the "never spent". Same for "indefinite".
        #
        convictions_by_date.each do |conviction|
          next if conviction == proceeding

          other_conviction_date = conviction.conviction_date
          other_spent_date = conviction.spent_date

          next unless spent_date.to_date.in?(
            other_conviction_date..other_spent_date.to_date
          )

          next if conviction_date > other_conviction_date

          # If the spent date falls inside another rehabilitation, we do drag-through.
          # The `spent_date` or the `other_spent_date` can be NEVER_SPENT or INDEFINITE.
          spent_date = other_spent_date
        end

        spent_date
      end

      def all_spent?
        results.values.all?(&:spent?)
      end

      private

      def convictions_by_date
        @_convictions ||= proceedings.select(&:conviction?).sort_by(&:conviction_date)
      end

      def process!
        disclosure_report.check_groups.with_completed_checks.each(&method(:process_group))
        self
      end

      def process_group(check_group)
        results[check_group.id] = if check_group.multiple_sentences?
                                    # multiple sentences inside the same proceedings
                                    SameProceedings.new(check_group)
                                  else
                                    # sentences given in separate proceedings
                                    SeparateProceedings.new(check_group)
                                  end
      end
    end
  end
end
