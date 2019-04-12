require 'rails_helper'

RSpec.describe Steps::Conviction::MilitaryController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Conviction::MilitaryForm, ConvictionDecisionTree
end
