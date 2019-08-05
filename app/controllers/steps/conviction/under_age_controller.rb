module Steps
  module Conviction
    class UnderAgeController < Steps::ConvictionStepController
      include BypassUnderAge

      def edit
        @form_object = UnderAgeForm.new(
          disclosure_check: current_disclosure_check,
          under_age: current_disclosure_check.under_age
        )
      end

      def update
        update_and_advance(UnderAgeForm, as: as_name)
      end
    end
  end
end
