module Steps
  module Mvp
    class InfoForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :opted_in

      def persist!
        record.update(
          opted_in: opted_in
        )
      end
    end
  end
end
