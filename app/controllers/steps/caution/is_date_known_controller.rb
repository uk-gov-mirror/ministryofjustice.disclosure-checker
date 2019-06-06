module Steps
  module Caution
    class IsDateKnownController < Steps::CautionStepController
      def edit
        @form_object = IsDateKnownForm.new(
          disclosure_check: current_disclosure_check,
          is_date_known: current_disclosure_check.is_date_known
        )
      end

      def update
        update_and_advance(IsDateKnownForm)
      end
    end
  end
end