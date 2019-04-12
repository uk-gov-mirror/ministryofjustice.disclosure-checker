module Steps
  module Conviction
    class FinancialController < Steps::ConvictionStepController
      def edit
        @form_object = FinancialForm.new(
          disclosure_check: current_disclosure_check,
          financial: current_disclosure_check.financial
        )
      end

      def update
        update_and_advance(FinancialForm)
      end
    end
  end
end
