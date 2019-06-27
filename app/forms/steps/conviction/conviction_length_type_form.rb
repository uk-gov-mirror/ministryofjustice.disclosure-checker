module Steps
  module Conviction
    class ConvictionLengthTypeForm < BaseForm
      attribute :conviction_length_type, String

      validates_inclusion_of :conviction_length_type, in: :choices, if: :disclosure_check

      def choices
        if conviction_type.eql?(ConvictionType::COMMUNITY_ORDER)
          ConvictionLengthType.values
        else
          ConvictionLengthType.values - [ConvictionLengthType::NO_LENGTH]
        end.map(&:to_s)
      end

      private

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update(
          conviction_length_type: conviction_length_type,
          conviction_length: nil
        )
      end
    end
  end
end
