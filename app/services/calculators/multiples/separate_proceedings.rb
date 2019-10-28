# TODO: pending things to code or clarify
#
#   - This calculator is not finished, it just returns the spent date for the
#     caution/conviction, nothing else. We are awaiting some clarifications.
#
module Calculators
  module Multiples
    class SeparateProceedings < BaseMultiplesCalculator
      def spent_date
        expiry_date_for(disclosure_check)
      end

      private

      # The only check inside this group
      def disclosure_check
        @_disclosure_check ||= disclosure_checks.first
      end
    end
  end
end
