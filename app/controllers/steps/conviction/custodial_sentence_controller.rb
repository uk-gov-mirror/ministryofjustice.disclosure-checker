module Steps
  module Conviction
    class CustodialSentenceController < Steps::ConvictionStepController
      def edit
        @form_object = CustodialSentenceForm.new(
          disclosure_check: current_disclosure_check,
          custodial_sentence: current_disclosure_check.custodial_sentence
        )
      end

      def update
        update_and_advance(CustodialSentenceForm)
      end
    end
  end
end
