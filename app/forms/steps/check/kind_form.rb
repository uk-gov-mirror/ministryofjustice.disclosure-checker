module Steps
  module Check
    class KindForm < BaseForm
      attribute :kind, String

      def self.choices
        CheckKind.string_values
      end

      validates_inclusion_of :kind, in: choices

      private

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update(
          kind: kind,
        )
      end
    end
  end
end
