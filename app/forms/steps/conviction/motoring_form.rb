module Steps
  module Conviction
    class MotoringForm < BaseForm
      attribute :motoring, String

      def self.choices
        Motoring.string_values
      end

      validates_inclusion_of :motoring, in: choices

      private

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update(
          motoring: motoring
        )
      end
    end
  end
end
