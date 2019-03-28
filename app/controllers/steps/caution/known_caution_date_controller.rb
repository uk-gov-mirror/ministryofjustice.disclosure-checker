module Steps
  module Caution
    class KnownCautionDateController < Steps::CautionStepController
      def edit
        @form_object = KnownCautionDateForm.new(
          disclosure_check: current_disclosure_check,
          known_caution_date: current_disclosure_check.known_caution_date
        )
      end

      def update
        update_and_advance(KnownCautionDateForm)
      end
    end
  end
end
