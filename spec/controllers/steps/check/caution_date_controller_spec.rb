require 'rails_helper'

RSpec.describe Steps::Check::CautionDateController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Check::CautionDateForm, CheckDecisionTree
end
