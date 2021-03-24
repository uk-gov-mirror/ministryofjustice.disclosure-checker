module Steps
  module Check
    class CautionOrConvictionForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :add_caution_or_conviction

      # There is no DB attribute for this form-object so we just return `true`
      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        true
      end
    end
  end
end
