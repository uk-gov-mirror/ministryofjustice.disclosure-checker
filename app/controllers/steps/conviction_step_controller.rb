module Steps
  class ConvictionStepController < StepController
    private

    def decision_tree_class
      ConvictionDecisionTree
    end
  end
end
