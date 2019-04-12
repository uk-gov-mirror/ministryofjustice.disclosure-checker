module Steps
  module Conviction
    class FinancialForm < BaseForm
      attribute :financial, String

      def self.choices
        Financial.string_values
      end

      validates_inclusion_of :financial, in: choices

      private

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update(
          financial: financial
        )
      end
    end
  end
end
