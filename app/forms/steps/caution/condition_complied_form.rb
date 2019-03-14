module Steps
  module Caution
    class ConditionCompliedForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :condition_complied
    end
  end
end
