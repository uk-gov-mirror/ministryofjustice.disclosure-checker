module Steps
  module Caution
    class ResultController < Steps::CautionStepController
      before_action :set_presenter

      def show; end

      private

      def set_presenter
        @presenter = CautionResultPresenter.new(current_disclosure_check)
      end
    end
  end
end
