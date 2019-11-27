module Steps
  module Conviction
    class MotoringDisqualificationEndDateController < Steps::ConvictionStepController
      def edit
        @form_object = MotoringDisqualificationEndDateForm.build(current_disclosure_check)
      end

      def update
        update_and_advance(MotoringDisqualificationEndDateForm, as: :motoring_disqualification_end_date)
      end
    end
  end
end
