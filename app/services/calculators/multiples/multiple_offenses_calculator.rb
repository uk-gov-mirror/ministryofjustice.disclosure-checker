module Calculators
  module Multiples
    class MultipleOffensesCalculator
      attr_reader :disclosure_report,
                  :results

      def initialize(disclosure_report)
        @disclosure_report = disclosure_report
        @results = {}
      end

      def process!
        disclosure_report.check_groups.with_completed_checks.each(&method(:process_group))
      end

      # rubocop:disable Metrics/AbcSize
      def spent_date_for(check_group)
        return unless results.any?

        spent_date = results[check_group.id].spent_date

        # Cautions are always dealt with separately and do not have drag-through
        return spent_date unless results[check_group.id].conviction?

        # We have to loop through the rest of convictions and check if the spent date
        # of this group overlaps with the spent date of another group and if so, then
        # the spent date of this group becomes the spent date of the other group.
        #
        results.values.select(&:conviction?).each do |conviction|
          other_spent_date = conviction.spent_date

          spent_date = ResultsVariant::NEVER_SPENT if other_spent_date == ResultsVariant::NEVER_SPENT
          spent_date = ResultsVariant::INDEFINITE  if other_spent_date == ResultsVariant::INDEFINITE

          # Continue with next conviction if it is a variant
          next unless spent_date.is_a?(Date)

          # If the spent date falls inside another rehabilitation, we do drag-through
          spent_date = other_spent_date if other_spent_date >= spent_date
        end

        spent_date
      end
      # rubocop:enable Metrics/AbcSize

      def all_spent?
        results.values.all?(&:spent?)
      end

      private

      def process_group(check_group)
        results[check_group.id] = if check_group.disclosure_checks.count > 1
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
