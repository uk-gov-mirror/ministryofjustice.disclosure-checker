module Steps
  module Caution
    class UnderAgeController < Steps::CautionStepController
      def edit
        @form_object = UnderAgeForm.build(current_disclosure_check)
      end

      def update
        update_and_advance(UnderAgeForm, as: :under_age)
      end
    end
  end
end
