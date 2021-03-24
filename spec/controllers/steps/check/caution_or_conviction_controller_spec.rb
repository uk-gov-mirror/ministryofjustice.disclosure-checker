require 'rails_helper'

RSpec.describe Steps::Check::CautionOrConvictionController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Check::CautionOrConvictionForm, CheckDecisionTree
end
