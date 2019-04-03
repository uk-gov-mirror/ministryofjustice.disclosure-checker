module Steps
  module Conviction
    class ConvictionDateController < Steps::ConvictionStepController
      def edit
        @form_object = ConvictionDateForm.new(
          disclosure_check: current_disclosure_check,
          conviction_date: current_disclosure_check.conviction_date
        )
      end

      def update
        update_and_advance(ConvictionDateForm, as: :conviction_date)
      end
    end
  end
end
