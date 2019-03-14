module Steps
  module Caution
    class ConditionCompliedController < Steps::CautionStepController
      def edit
        @form_object = ConditionCompliedForm.new(
          disclosure_check: current_disclosure_check,
          condition_complied: current_disclosure_check.condition_complied
        )
      end

      def update
        update_and_advance(ConditionCompliedForm, as: :condition_complied)
      end
    end
  end
end
