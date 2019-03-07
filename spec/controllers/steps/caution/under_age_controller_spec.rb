require 'rails_helper'

RSpec.describe Steps::Caution::UnderAgeController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Caution::UnderAgeForm, CautionDecisionTree
end
