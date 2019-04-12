require 'rails_helper'

RSpec.describe Steps::Conviction::FinancialController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Conviction::FinancialForm, ConvictionDecisionTree
end
