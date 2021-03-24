module Steps
  module Check
    class CautionOrConvictionController < Steps::CheckStepController
      def edit
        @form_object = CautionOrConvictionForm.build(current_disclosure_check)
      end

      def update
        update_and_advance(CautionOrConvictionForm)
      end
    end
  end
end
