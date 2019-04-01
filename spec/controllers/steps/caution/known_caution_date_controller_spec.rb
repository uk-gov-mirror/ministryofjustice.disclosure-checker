require 'rails_helper'

RSpec.describe Steps::Caution::KnownCautionDateController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Caution::KnownCautionDateForm, CautionDecisionTree
end
