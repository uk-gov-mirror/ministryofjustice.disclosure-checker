module Steps
  class <%= task_name.camelize %>StepController < StepController
    private

    def decision_tree_class
      <%= task_name.camelize %>DecisionTree
    end
  end
end
