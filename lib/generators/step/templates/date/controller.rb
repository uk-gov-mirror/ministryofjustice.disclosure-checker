module Steps
  module <%= task_name.camelize %>
    class <%= step_name.camelize %>Controller < Steps::<%= task_name.camelize %>StepController
      def edit
        @form_object = <%= step_name.camelize %>Form.new(
          disclosure_check: current_disclosure_check,
          <%= step_name.underscore  %>: current_disclosure_check.<%= step_name.underscore %>
        )
      end

      def update
        update_and_advance(<%= step_name.camelize %>Form, as: :<%= step_name.underscore.to_sym %>)
      end
    end
  end
end
