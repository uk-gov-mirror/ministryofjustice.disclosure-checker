module Steps
  module Check
    class UnderAgeForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :under_age

      def i18n_attribute
        disclosure_check.kind
      end
    end
  end
end
