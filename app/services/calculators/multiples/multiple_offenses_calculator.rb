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

        # We have to loop through the other convictions and check if the spent date
        # of this conviction overlaps with the rehabilitation of another one and if so,
        # then the spent date of this conviction becomes the spent date of the other.
        #
        # We get the position of this conviction in the collection (for example in a
        # collection of 4 convictions, if it is the first one it returns 0 and if it is
        # the last one it returns 3). We use this to know where to start to iterate, as
        # we only need to iterate through the convictions left, starting with this one.
        #
        position = convictions_by_date.index(proceeding)

        convictions_by_date.values_at(position..).each do |conviction|
          other_conviction_date = conviction.conviction_date
          other_spent_date = conviction.spent_date

          next unless spent_date.to_date.in?(
            other_conviction_date..other_spent_date.to_date
          )

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
