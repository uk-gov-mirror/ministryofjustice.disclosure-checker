module Steps
  module Caution
    class KnownDateController < Steps::CautionStepController
      def edit
        @form_object = KnownDateForm.new(
          disclosure_check: current_disclosure_check,
          known_date: current_disclosure_check.known_date
        )
      end

      def update
        update_and_advance(KnownDateForm, as: :known_date)
      end
    end
  end
end
