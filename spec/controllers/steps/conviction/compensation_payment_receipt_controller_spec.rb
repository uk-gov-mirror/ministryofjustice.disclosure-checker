require 'rails_helper'

RSpec.describe Steps::Conviction::CompensationPaymentReceiptController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Conviction::CompensationPaymentReceiptForm, ConvictionDecisionTree
end
