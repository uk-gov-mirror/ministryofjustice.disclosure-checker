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
        current_spent_date = proceeding.spent_date

        # Cautions are always dealt with separately and do not have drag-through
        return spent_date unless proceeding.conviction?

        # Comparison of dates between different convictions
        # should be done without relevant order dates
        spent_date_without_relevant_order = proceeding.spent_date_without_relevant_orders

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
        # convictions_by_date.map(&:conviction_date)
        # [conviction_B, conviction_A, conviction_C]
        # => [Sat, 01 Jan 2000, Mon, 01 Jan 2001, Fri, 01 Mar 2002]

        # convictions_by_date.map(&:spent_date_without_relevant_orders)
        # => [Fri, 01 Feb 2002, Wed, 01 Jan 2003, Thu, 01 Jun 2006]

        conviction_B, conviction_A, conviction_C = convictions_by_date


        convictions_by_date.without(proceeding).each do |conviction|
          other_conviction_date = conviction.conviction_date
          other_spent_date = conviction.new_spent_date.nil? ? conviction.spent_date_without_relevant_orders : conviction.new_spent_date

          # solo relevant order
          # if there's only one sentence and it is a relevant order
          # then _spent_date_without_relevant_orders_ is nil which means it's not a date
          # and we can't proceed to compare overlapping times (neither should we)
          # because relevant orders do not dictacte the spent_date of another conviction.
          next if other_spent_date.nil?
          next if spent_date_without_relevant_order.nil?

          # the comparison to know if there's an overlap in conviction dates
          # should be done without the relevant order
          # because relevant orders do not dictacte the spent_date of another conviction.

          # Conviction A compares with Conviction B
          # => Wed, 01 Jan 2003 in? (Sat, 01 Jan 2000 .. Fri, 01 Feb 2002)
          # => false

          # Conviction A compares with conviction C
          # => 2003-01-01 in ? 2002-03-01 .. 2006-06-01
          # => true
          # Conviction A spent date becomes Conviction C
          # spent date: 2006, 6, 1
          # Although we have already compared A with B
          # meaning that Conviction B won't be affected because
          # Conviction C does not overlap with Conviction B

          puts "#{spent_date_without_relevant_order} in ? #{other_conviction_date} .. #{other_spent_date}"

          # spent_date_without_relevant_order.to_date.in?( other_conviction_date..other_spent_date.to_date )
          # binding.pry

          next unless spent_date_without_relevant_order.to_date.in?(
            other_conviction_date..other_spent_date.to_date
          )

          puts "#{conviction_date} > #{other_conviction_date} = #{conviction_date > other_conviction_date}"
          puts conviction_date > other_conviction_date

          puts "conviction A: #{conviction == conviction_A}"
          puts "conviction B: #{conviction == conviction_B}"
          puts "conviction C: #{conviction == conviction_C}"

          puts "proceeding A: #{proceeding == conviction_A}"
          puts "proceeding B: #{proceeding == conviction_B}"
          puts "proceeding C: #{proceeding == conviction_C}"

          next if conviction_date > other_conviction_date

          # binding.pry

          # If the spent date falls inside another rehabilitation, we do drag-through.
          # The `spent_date` or the `other_spent_date` can be NEVER_SPENT or INDEFINITE.
          spent_date = other_spent_date
          proceeding.new_spent_date = spent_date
        end

        spent_date
      end

      def all_spent?
        proceedings.all?(&:spent?)
      end

      private

      def convictions_by_date
        @_convictions = proceedings.select(&:conviction?).sort_by(&:conviction_date)
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
