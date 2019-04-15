module Steps
  module Conviction
    class RehabilitationPreventionOrderController < Steps::ConvictionStepController
      def edit
        @form_object = RehabilitationPreventionOrderForm.new(
          disclosure_check: current_disclosure_check,
          rehabilitation_prevention_order: current_disclosure_check.rehabilitation_prevention_order
        )
      end

      def update
        update_and_advance(RehabilitationPreventionOrderForm)
      end
    end
  end
end
