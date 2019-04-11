module Steps
  module Conviction
    class CustodialSentenceForm < BaseForm
      attribute :custodial_sentence, String

      def self.choices
        CustodialSentence.string_values
      end

      validates_inclusion_of :custodial_sentence, in: choices

      private

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update(
          custodial_sentence: custodial_sentence
        )
      end
    end
  end
end
