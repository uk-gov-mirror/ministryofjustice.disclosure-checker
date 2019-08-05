module Steps
  module Conviction
    class ConvictionTypeForm < BaseForm
      attribute :conviction_type, String

      validates_inclusion_of :conviction_type, in: :choices, if: :disclosure_check

      def choices
        if under_age?
          ConvictionType::YOUTH_PARENT_TYPES
        else
          ConvictionType::ADULT_PARENT_TYPES
        end.map(&:to_s)
      end

      private

      def under_age?
        disclosure_check.under_age.inquiry.yes?
      end

      def changed?
        disclosure_check.conviction_type != conviction_type
      end

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check
        return true unless changed?

        disclosure_check.update(
          conviction_type: conviction_type,
          # The following are dependent attributes that need to be reset if form changes
          conviction_subtype: nil
        )
      end
    end
  end
end
