module Steps
  class ConvictionStepController < StepController
    private

    # :nocov:
    # TODO: This will be removed once the conviction path is started
    def decision_tree_class
      ConvictionDecisionTree
    end
    # :nocov:
  end
end
