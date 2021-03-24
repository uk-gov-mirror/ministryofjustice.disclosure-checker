module Steps
  module Check
    class CautionOrConvictionController < Steps::CheckStepController
      def edit
        @form_object = CautionOrConvictionForm.new(disclosure_check: current_disclosure_check)
      end

      def update
        if new_caution_or_conviction?
          initialize_disclosure_check(
            navigation_stack: navigation_stack,
            disclosure_report: current_disclosure_report
          )

          redirect_to edit_steps_check_kind_path
        else
          redirect_to steps_check_results_path(show_results: true)
        end
      end

      private

      def new_caution_or_conviction?
        GenericYesNo.new(
          params[:steps_check_caution_or_conviction_form][:add_caution_or_conviction]
        ).yes?
      end

      def navigation_stack
        [steps_check_check_your_answers_path]
      end
    end
  end
end
