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

      # TODO: This needs confirmation, please visit the following card https://trello.com/c/sZ7qBDwe/
      def expiry_dates
        if all_proceedings_are_relevant_orders? || no_relevant_orders?
          @_expiry_dates ||= disclosure_checks.map(
            &method(:expiry_date_for)
          )
        else
          expire_date = expiry_date_for(conviction_with_relevant_order)
          expiry_dates = proceedings_without_relevant_order.map(&method(:expiry_date_for))

          if expiry_dates.max < expire_date
            expiry_dates
          else
            [expire_date]
          end
        end
      end

      def all_proceedings_are_relevant_orders?
        disclosure_checks.all? { |disclosure_check| disclosure_check.relevant_order? }
      end

      def no_relevant_orders?
        disclosure_checks.none? { |disclosure_check| disclosure_check.relevant_order? }
      end

      # NOTE: Currently we don't the exact behaviour, so I've taken the longest relevant order if there's more than one.
      # See the following card for more clarification, when provided: https://trello.com/c/sZ7qBDwe/
      def conviction_with_relevant_order
        relevant_orders = disclosure_checks.select { |disclosure_check| disclosure_check.relevant_order? }
        relevant_orders.max_by { |relevant_order| relevant_order.conviction_length }
      end

      def proceedings_without_relevant_order
        disclosure_checks - [conviction_with_relevant_order]
      end
    end
  end
end
