module Steps
  module Check
    class KindController < Steps::CheckStepController
      include StartingPointStep

      def edit
        @form_object = KindForm.build(current_disclosure_check)
      end

      def update
        update_and_advance(KindForm, as: :kind)
      end
    end
  end
end
