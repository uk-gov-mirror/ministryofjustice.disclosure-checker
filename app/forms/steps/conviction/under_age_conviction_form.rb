module Steps
  module Conviction
    class UnderAgeConvictionForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :under_age_conviction
    end
  end
end
