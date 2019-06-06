module Steps
  module Conviction
    class IsDateKnownForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :is_date_known
    end
  end
end
