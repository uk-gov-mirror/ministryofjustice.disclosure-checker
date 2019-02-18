module Steps
  module Caution
    class CautionDateController < Steps::CautionStepController
      def edit
        @form_object = CautionDateForm.new(
          disclosure_check: current_disclosure_check,
          caution_date: current_disclosure_check.caution_date
        )
      end

      def update
        update_and_advance(CautionDateForm, as: :caution_date)
      end
    end
  end
end
