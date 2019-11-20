module Steps
  module Conviction
    class ConvictionBailForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :conviction_bail
    end
  end
end
