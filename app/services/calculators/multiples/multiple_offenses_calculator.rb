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

        spent_date = proceeding.spent_date

        # Cautions are always dealt with separately and do not have drag-through
        return spent_date unless proceeding.conviction?

        # We have to loop through the rest of convictions and check if the spent date
        # of this group overlaps with the spent date of another group and if so, then
        # the spent date of this group becomes the spent date of the other group.
        #
        convictions_by_start_date.each do |conviction|
          other_start_date = conviction.start_date
          other_spent_date = conviction.spent_date

          spent_date = ResultsVariant::NEVER_SPENT if other_spent_date == ResultsVariant::NEVER_SPENT
          spent_date = ResultsVariant::INDEFINITE  if other_spent_date == ResultsVariant::INDEFINITE

          # Continue with next conviction if it is a variant
          next unless spent_date.is_a?(Date)

          # If the spent date falls inside another rehabilitation, we do drag-through
          spent_date = other_spent_date if spent_date.in?(other_start_date..other_spent_date)
        end

        spent_date
      end

      def all_spent?
        results.values.all?(&:spent?)
      end

      private

      def convictions_by_start_date
        @_convictions ||= proceedings.select(&:conviction?).sort_by(&:start_date)
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
