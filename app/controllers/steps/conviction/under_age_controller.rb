module Steps
  module Conviction
    class UnderAgeController < Steps::ConvictionStepController
      def edit
        @form_object = UnderAgeForm.new(
          disclosure_check: current_disclosure_check,
          under_age: current_disclosure_check.under_age
        )
      end

      def update
        update_and_advance(UnderAgeForm)
      end
    end
  end
end
