module Steps
  class CautionStepController < StepController
    private

    def decision_tree_class
      CautionDecisionTree
    end
  end
end
