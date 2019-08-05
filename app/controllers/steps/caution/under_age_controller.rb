module Steps
  module Caution
    class UnderAgeController < Steps::CautionStepController
      include BypassUnderAge

      def edit
        @form_object = UnderAgeForm.build(current_disclosure_check)
      end

      def update
        update_and_advance(UnderAgeForm, as: as_name)
      end
    end
  end
end
