module Steps
  module Conviction
    class ConvictionLengthForm < BaseForm
      attribute :conviction_length, Integer
      attribute :conviction_length_type, String

      def self.choices
        ConvictionLengthType.string_values
      end

      validates_inclusion_of :conviction_length_type, in: choices
      validates_numericality_of :conviction_length, greater_than: 0, only_integer: true

      private

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update(
          conviction_length_type: conviction_length_type,
          conviction_length: conviction_length
        )
      end
    end
  end
end
