# TODO: pending things to code or clarify
#
#   - Calculation changes for prison sentences (consecutive or concurrent).
#   - What to do with `indefinite` (at the moment we mark the whole conviction as indefinite).
#
module Calculators
  module Multiples
    class SameProceedings < BaseMultiplesCalculator
      def spent_date
        return ResultsVariant::NEVER_SPENT if expiry_dates.include?(ResultsVariant::NEVER_SPENT)
        return ResultsVariant::INDEFINITE  if expiry_dates.include?(ResultsVariant::INDEFINITE)

        # Pick the latest date in the collection
        # All sentences in same proceedings start the same date, overlapping
        expiry_dates.max
      end

      def spent_date_without_relevant_orders
        @_spent_date_without_relevant_orders ||= without_relevant_orders.map(
          &method(:expiry_date_for)
        ).max
      end

      private

      def expiry_dates
        @_expiry_dates ||= disclosure_checks.map(
          &method(:expiry_date_for)
        )
      end
    end
  end
end
