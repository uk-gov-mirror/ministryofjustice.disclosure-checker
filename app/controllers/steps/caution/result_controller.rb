module Steps
  module Caution
    class ResultController < Steps::CautionStepController
      include CompletionStep

      def show
        @presenter = CautionResultPresenter.new(current_disclosure_check)
      end
    end
  end
end
