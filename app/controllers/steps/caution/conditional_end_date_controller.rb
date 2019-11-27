module Steps
  module Caution
    class ConditionalEndDateController < Steps::CautionStepController
      def edit
        @form_object = ConditionalEndDateForm.build(current_disclosure_check)
      end

      def update
        update_and_advance(ConditionalEndDateForm, as: :conditional_end_date)
      end
    end
  end
end
