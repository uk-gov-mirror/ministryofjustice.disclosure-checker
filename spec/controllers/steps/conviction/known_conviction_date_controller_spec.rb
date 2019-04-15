require 'rails_helper'

RSpec.describe Steps::Conviction::KnownConvictionDateController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Conviction::KnownConvictionDateForm, ConvictionDecisionTree
end