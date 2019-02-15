module Steps
  module Check
    class CautionDateController < Steps::CheckStepController
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
