module Calculators
  module Multiples
    class MultipleOffensesCalculator
      attr_reader :disclosure_report
      attr_reader :results

      def initialize(disclosure_report)
        @disclosure_report = disclosure_report
        @results = {}
      end

      def process!
        disclosure_report.check_groups.with_completed_checks.each(&method(:process_group))
      end

      def spent_date_for(check_group)
        results[check_group.id].spent_date
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
