module Steps
  module Conviction
    class ConvictionDateController < Steps::ConvictionStepController
      def edit
        @form_object = ConvictionDateForm.build(current_disclosure_check)
      end

      def update
        update_and_advance(ConvictionDateForm, as: :conviction_date)
      end
    end
  end
end
