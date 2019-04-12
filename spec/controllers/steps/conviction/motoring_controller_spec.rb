require 'rails_helper'

RSpec.describe Steps::Conviction::MotoringController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Conviction::MotoringForm, ConvictionDecisionTree
end
