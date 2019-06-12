module Steps
  module Conviction
    class ConvictionLengthTypeForm < BaseForm
      attribute :conviction_length_type, String

      def self.choices
        ConvictionLengthType.string_values
      end

      validates_inclusion_of :conviction_length_type, in: choices

      private

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update(
          conviction_length_type: conviction_length_type
        )
      end
    end
  end
end
