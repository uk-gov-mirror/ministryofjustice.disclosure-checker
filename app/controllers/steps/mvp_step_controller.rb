module Steps
  class MvpStepController < StepController
    skip_before_action :check_http_credentials,
                       :check_disclosure_check_presence,
                       :check_disclosure_check_not_completed

    private

    def decision_tree_class
      MvpDecisionTree
    end
  end
end
