module Steps
  module Conviction
    class ConvictionSubtypeForm < BaseForm
      attribute :conviction_subtype, String

      validates_inclusion_of :conviction_subtype, in: :choices, if: :disclosure_check

      def choices
        conviction_subtypes.map(&:to_s)
      end

      def conviction_type
        disclosure_check.conviction_type
      end

      private

      def conviction_subtypes
        ConvictionType.new(conviction_type).children
      end

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update(
          conviction_subtype: conviction_subtype
        )
      end
    end
  end
end
