module Steps
  module Conviction
    class RehabilitationPreventionOrderForm < BaseForm
      attribute :rehabilitation_prevention_order, String

      def self.choices
        RehabilitationPreventionOrder.string_values
      end

      validates_inclusion_of :rehabilitation_prevention_order, in: choices

      private

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update(
          rehabilitation_prevention_order: rehabilitation_prevention_order
        )
      end
    end
  end
end
