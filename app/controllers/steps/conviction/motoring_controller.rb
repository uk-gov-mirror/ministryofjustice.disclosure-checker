module Steps
  module Conviction
    class MotoringController < Steps::ConvictionStepController
      def edit
        @form_object = MotoringForm.new(
          disclosure_check: current_disclosure_check,
          motoring: current_disclosure_check.motoring
        )
      end

      def update
        update_and_advance(MotoringForm)
      end
    end
  end
end
