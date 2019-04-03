module Steps
  module Conviction
    class UnderAgeConvictionController < Steps::ConvictionStepController
      def edit
        @form_object = UnderAgeConvictionForm.new(
          disclosure_check: current_disclosure_check,
          under_age_conviction: current_disclosure_check.under_age_conviction
        )
      end

      def update
        update_and_advance(UnderAgeConvictionForm)
      end
    end
  end
end
