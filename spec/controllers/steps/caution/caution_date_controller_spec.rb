require 'rails_helper'

RSpec.describe Steps::Caution::CautionDateController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Caution::CautionDateForm, CautionDecisionTree
end
