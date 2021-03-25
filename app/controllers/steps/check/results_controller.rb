module Steps
  module Check
    class ResultsController < Steps::CheckStepController
      include CompletionStep

      append_before_action :show_check_answers_if_enabled, only: [:show]

      def show
        @presenter = CheckAnswersPresenter.new(current_disclosure_report, show_spent_date_panel: true)

        render variants: @presenter.variant
      end

      private

      def show_check_answers_if_enabled
        redirect_to steps_check_check_your_answers_path if show_check_answers?
      end

      def show_check_answers?
        params[:show_results].blank?
      end
    end
  end
end
