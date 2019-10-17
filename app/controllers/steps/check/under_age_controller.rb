module Steps
  module Check
    class UnderAgeController < Steps::CheckStepController
      def edit
        @form_object = UnderAgeForm.build(current_disclosure_check)
      end

      def update
        update_and_advance(UnderAgeForm, as: as_name)
      end

      private

      # TODO: temporary feature-flag, to be removed when no needed
      def as_name
        adults_enabled? ? :bypass_under_age : :under_age
      end
    end
  end
end
