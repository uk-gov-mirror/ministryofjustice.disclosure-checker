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

      private

      def expiry_dates
        expiration_dates
      end

      def expiration_dates
        return expiry_date_for_all_sentences if all_are_relevant_orders? || no_relevant_orders?

        expiry_date_without_relevant_orders
      end

      def all_are_relevant_orders?
        disclosure_checks.all?(&:relevant_order?)
      end

      def no_relevant_orders?
        disclosure_checks.none?(&:relevant_order?)
      end

      def relevant_orders
        @_relevant_orders ||= disclosure_checks.select(&:relevant_order?)
      end

      def expiry_date_for_all_sentences
        @_expiry_date_for_all_sentences ||= disclosure_checks.map(&method(:expiry_date_for))
      end

      def sentences_without_relevant_orders
        (disclosure_checks - relevant_orders)
      end

      # When a conviction contains multiple sentences where one is a relevant order,
      # the relevant order is not taken into account for drag-through purposes
      # Given that same proceedings cares about the maximum date,
      # we simply take away the relevant orders and return the expiry date of a non relevant order
      # See the following card for more clarification, when provided: https://trello.com/c/sZ7qBDwe/
      def expiry_date_without_relevant_orders
        sentences_without_relevant_orders.map(&method(:expiry_date_for))
      end
    end
  end
end
