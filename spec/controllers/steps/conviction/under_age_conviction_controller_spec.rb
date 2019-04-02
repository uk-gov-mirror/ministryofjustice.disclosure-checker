require 'rails_helper'

RSpec.describe Steps::Conviction::UnderAgeConvictionController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Conviction::UnderAgeConvictionForm, ConvictionDecisionTree
end
