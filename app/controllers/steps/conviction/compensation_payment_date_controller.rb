module Steps
  module Conviction
    class CompensationPaymentDateController < Steps::ConvictionStepController
      def edit
        @form_object = CompensationPaymentDateForm.build(current_disclosure_check)
      end

      def update
        update_and_advance(CompensationPaymentDateForm, as: :compensation_payment_date)
      end
    end
  end
end
