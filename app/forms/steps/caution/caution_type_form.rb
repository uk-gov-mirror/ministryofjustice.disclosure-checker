module Steps
  module Caution
    class CautionTypeForm < BaseForm
      attribute :caution_type, String

      validates_inclusion_of :caution_type, in: :choices, if: :disclosure_check

      def choices
        if under_age?
          CautionType::YOUTH_VALUES
        else
          CautionType::NON_YOUTH_VALUES
        end.map(&:to_s)
      end

      private

      def under_age?
        disclosure_check.under_age.inquiry.yes?
      end

      def changed?
        disclosure_check.caution_type != caution_type
      end

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check
        return true unless changed?

        disclosure_check.update(
          caution_type: caution_type,
          # The following are dependent attributes that need to be reset if form changes
          known_date: nil,
          conditional_end_date: nil
        )
      end
    end
  end
end
