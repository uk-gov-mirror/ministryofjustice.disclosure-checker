module Steps
  module Conviction
    class KnownConvictionDateForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :known_conviction_date
    end
  end
end
