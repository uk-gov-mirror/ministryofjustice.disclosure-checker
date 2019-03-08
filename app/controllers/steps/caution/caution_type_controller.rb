module Steps
  module Caution
    class CautionTypeController < Steps::CautionStepController
      def edit
        @form_object = CautionTypeForm.build(current_disclosure_check)
      end

      def update
        update_and_advance(CautionTypeForm, as: :caution_type)
      end
    end
  end
end
