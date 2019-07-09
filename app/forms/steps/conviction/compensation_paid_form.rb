module Steps
  module Conviction
    class CompensationPaidForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :compensation_paid, reset_when_no: [:compensation_payment_date]
    end
  end
end
