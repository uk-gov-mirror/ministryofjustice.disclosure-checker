require 'rails_helper'

RSpec.describe Steps::Conviction::ConvictionEndDateController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Conviction::ConvictionEndDateForm, ConvictionDecisionTree
end
