require 'rails_helper'

RSpec.describe Steps::Conviction::CommunityOrderController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Conviction::CommunityOrderForm, ConvictionDecisionTree
end
