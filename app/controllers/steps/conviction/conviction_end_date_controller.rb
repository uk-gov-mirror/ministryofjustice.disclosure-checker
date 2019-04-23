module Steps
  module Conviction
    class ConvictionEndDateController < Steps::ConvictionStepController
      def edit
        @form_object = ConvictionEndDateForm.new(
          disclosure_check: current_disclosure_check,
          conviction_end_date: current_disclosure_check.conviction_end_date
        )
      end

      def update
        update_and_advance(ConvictionEndDateForm, as: :conviction_end_date)
      end
    end
  end
end
