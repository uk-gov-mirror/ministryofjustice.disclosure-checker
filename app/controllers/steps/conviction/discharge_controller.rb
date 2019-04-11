module Steps
  module Conviction
    class DischargeController < Steps::ConvictionStepController
      def edit
        @form_object = DischargeForm.new(
          disclosure_check: current_disclosure_check,
          discharge: current_disclosure_check.discharge
        )
      end

      def update
        update_and_advance(DischargeForm)
      end
    end
  end
end
