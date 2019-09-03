module Steps
  module Check
    class ResultsController < Steps::CheckStepController
      include CompletionStep

      def show
        @presenter = ResultsPresenter.build(current_disclosure_check)
        render variants: @presenter.variant
      end
    end
  end
end
