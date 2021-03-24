module Steps
  module Check
    class CautionOrConvictionForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :add_caution_or_conviction
    end
  end
end
