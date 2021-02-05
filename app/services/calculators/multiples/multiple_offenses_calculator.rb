module Calculators
  module Multiples
    class MultipleOffensesCalculator
      attr_reader :disclosure_report,
                  :proceedings

      def initialize(disclosure_report)
        @disclosure_report = disclosure_report
        @proceedings = []

        process!
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
        convictions_by_date.without(proceeding).each do |conviction|
          other_conviction_date = conviction.conviction_date
          other_spent_date = conviction.spent_date_without_relevant_orders

          # solo relevant order
          next if other_spent_date.nil?

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
        proceedings.all?(&:spent?)
      end

      private

      def convictions_by_date
        @_convictions ||= proceedings.select(&:conviction?).sort_by(&:conviction_date)
      end

      # The order of the `proceedings` collection is the order in which
      # the user entered their cautions and/or convictions.
      def process!
        disclosure_report.check_groups.with_completed_checks.each do |check_group|
          @proceedings.append(Proceedings.new(check_group))
        end

        self
      end
    end
  end
end
