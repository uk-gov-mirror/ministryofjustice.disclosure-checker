module Calculators
  module Multiples
    class SeparateProceedings < BaseMultiplesCalculator
      def spent_date
        expiry_date_for(disclosure_check)
      end

      def relevant_order?
        disclosure_check.relevant_order?
      end

      def spent_date_without_relevant_orders
        return nil if relevant_order?

        spent_date
      end

      private

      # The only check inside this group
      def disclosure_check
        @_disclosure_check ||= first_disclosure_check
      end
    end
  end
end
