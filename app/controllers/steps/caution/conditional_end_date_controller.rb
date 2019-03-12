module Steps
  module Caution
    class ConditionalEndDateController < Steps::CautionStepController
      def edit
        @form_object = ConditionalEndDateForm.new(
          disclosure_check: current_disclosure_check,
          conditional_end_date: current_disclosure_check.conditional_end_date
        )
      end

      def update
        update_and_advance(ConditionalEndDateForm, as: :conditional_end_date)
      end
    end
  end
end
