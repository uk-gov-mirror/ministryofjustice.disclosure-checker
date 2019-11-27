module Steps
  module Caution
    class KnownDateController < Steps::CautionStepController
      def edit
        @form_object = KnownDateForm.build(current_disclosure_check)
      end

      def update
        update_and_advance(KnownDateForm, as: :known_date)
      end
    end
  end
end
