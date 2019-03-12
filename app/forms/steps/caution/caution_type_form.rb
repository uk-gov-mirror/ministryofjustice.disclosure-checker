module Steps
  module Caution
    class CautionTypeForm < BaseForm
      attribute :caution_type, String

      validates_inclusion_of :caution_type, in: :choices

      def choices
        if under_age?
          CautionType::YOUTH_VALUES
        else
          CautionType::NON_YOUTH_VALUES
        end.map(&:to_s)
      end

      private

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update(
          caution_type: caution_type
        )
      end

      def under_age?
        disclosure_check&.under_age == 'yes'
      end
    end
  end
end
