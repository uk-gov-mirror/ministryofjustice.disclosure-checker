module Calculators
  module Multiples
    class MultipleOffensesCalculator
      attr_reader :disclosure_report
      attr_reader :results

      def initialize(disclosure_report)
        @disclosure_report = disclosure_report
        @results = []
      end

      def process!
        disclosure_report.check_groups.with_completed_checks.each(&method(:process_group))
      end

      def spent_date_for(check_group)
        results.find { |p| p.check_group == check_group }.spent_date
      end

      private

      # rubocop:disable Style/ConditionalAssignment
      def process_group(check_group)
        if check_group.disclosure_checks.count > 1
          # multiple sentences inside the same proceedings
          results << SameProceedings.new(check_group)
        else
          # sentences given in separate proceedings
          results << SeparateProceedings.new(check_group)
        end
      end
      # rubocop:enable Style/ConditionalAssignment
    end
  end
end
