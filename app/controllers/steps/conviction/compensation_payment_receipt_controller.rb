module Steps
  module Conviction
    class CompensationPaymentReceiptController < Steps::ConvictionStepController
      def edit
        @form_object = CompensationPaymentReceiptForm.build(current_disclosure_check)
      end

      def update
        update_and_advance(CompensationPaymentReceiptForm)
      end
    end
  end
end
