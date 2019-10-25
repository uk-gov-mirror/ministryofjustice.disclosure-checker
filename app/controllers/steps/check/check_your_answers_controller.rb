module Steps
  module Check
    class CheckYourAnswersController < Steps::CheckStepController
      before_action :check_disclosure_report_not_completed, only: [:show]

      def show
        @presenter = CheckAnswersPresenter.new(current_disclosure_report)
      end
    end
  end
end
