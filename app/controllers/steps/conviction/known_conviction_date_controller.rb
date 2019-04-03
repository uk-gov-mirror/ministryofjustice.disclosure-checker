module Steps
  module Conviction
    class KnownConvictionDateController < Steps::ConvictionStepController
      def edit
        @form_object = KnownConvictionDateForm.new(
          disclosure_check: current_disclosure_check,
          known_conviction_date: current_disclosure_check.known_conviction_date
        )
      end

      def update
        update_and_advance(KnownConvictionDateForm)
      end
    end
  end
end
