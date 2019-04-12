module Steps
  module Conviction
    class MilitaryController < Steps::ConvictionStepController
      def edit
        @form_object = MilitaryForm.new(
          disclosure_check: current_disclosure_check,
          military: current_disclosure_check.military
        )
      end

      def update
        update_and_advance(MilitaryForm)
      end
    end
  end
end
