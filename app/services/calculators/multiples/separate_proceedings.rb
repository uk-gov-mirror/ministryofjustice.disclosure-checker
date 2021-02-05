module Calculators
  module Multiples
    class SeparateProceedings < BaseMultiplesCalculator
      def spent_date
        expiry_date_for(disclosure_check)
      end

      private

      # The only check inside this group
      def disclosure_check
        @_disclosure_check ||= first_disclosure_check
      end
    end
  end
end
