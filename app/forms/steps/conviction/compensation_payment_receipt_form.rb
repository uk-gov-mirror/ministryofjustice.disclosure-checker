module Steps
  module Conviction
    class CompensationPaymentReceiptForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :compensation_receipt_sent
    end
  end
end
