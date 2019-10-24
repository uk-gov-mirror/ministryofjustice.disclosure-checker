# TODO: pending things to code or clarify
#
#   - Calculation changes for prison sentences (consecutive or concurrent).
#   - What to do with `no_record` (at the moment we ignore them).
#
module Calculators
  module Multiples
    class SameProceedings < BaseMultiplesCalculator
      def spent_date
        return :never_spent if expiry_dates.include?(:never_spent)

        # Pick the latest date in the collection
        expiry_dates.max
      end

      private

      def expiry_dates
        @_expiry_dates ||= check_group.disclosure_checks.map(
          &method(:expiry_date_for)
        ) - excluded_dates
      end

      def excluded_dates
        [:no_record].freeze
      end
    end
  end
end
