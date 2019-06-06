require 'rails_helper'

RSpec.describe Steps::Conviction::UnderAgeController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Conviction::UnderAgeForm, ConvictionDecisionTree
end
