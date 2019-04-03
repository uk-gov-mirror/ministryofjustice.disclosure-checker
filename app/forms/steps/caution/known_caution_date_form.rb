module Steps
  module Caution
    class KnownCautionDateForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :known_caution_date
    end
  end
end
