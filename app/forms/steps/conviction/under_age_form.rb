module Steps
  module Conviction
    class UnderAgeForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :under_age
    end
  end
end
