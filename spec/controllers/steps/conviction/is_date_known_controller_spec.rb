require 'rails_helper'

RSpec.describe Steps::Conviction::IsDateKnownController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Conviction::IsDateKnownForm, ConvictionDecisionTree
end
