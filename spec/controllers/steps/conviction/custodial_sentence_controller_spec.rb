require 'rails_helper'

RSpec.describe Steps::Conviction::CustodialSentenceController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Conviction::CustodialSentenceForm, ConvictionDecisionTree
end
