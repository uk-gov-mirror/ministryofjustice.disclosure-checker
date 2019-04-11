module Steps
  module Conviction
    class DischargeForm < BaseForm
      attribute :discharge, String

      def self.choices
        Discharge.string_values
      end

      validates_inclusion_of :discharge, in: choices

      private

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update(
          discharge: discharge
        )
      end
    end
  end
end
