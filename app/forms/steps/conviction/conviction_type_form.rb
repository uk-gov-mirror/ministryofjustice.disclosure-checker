module Steps
  module Conviction
    class ConvictionTypeForm < BaseForm
      attribute :conviction_type, String

      def self.choices
        ConvictionType::PARENT_TYPES.map(&:to_s)
      end
      validates_inclusion_of :conviction_type, in: choices

      private

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
