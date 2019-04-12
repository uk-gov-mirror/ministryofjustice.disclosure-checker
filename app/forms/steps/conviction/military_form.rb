module Steps
  module Conviction
    class MilitaryForm < BaseForm
      attribute :military, String

      def self.choices
        Military.string_values
      end

      validates_inclusion_of :military, in: choices

      private

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update(
          military: military
        )
      end
    end
  end
end
