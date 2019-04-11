module Steps
  module Conviction
    class CommunityOrderForm < BaseForm
      attribute :community_order, String

      def self.choices
        CommunityOrder.string_values
      end

      validates_inclusion_of :community_order, in: choices

      private

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update(
          community_order: community_order
        )
      end
    end
  end
end
