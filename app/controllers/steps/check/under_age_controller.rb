module Steps
  module Check
    class UnderAgeController < Steps::CheckStepController
      include BypassUnderAge

      def edit
        @form_object = UnderAgeForm.build(current_disclosure_check)
      end

      def update
        update_and_advance(UnderAgeForm, as: as_name)
      end
    end
  end
end
