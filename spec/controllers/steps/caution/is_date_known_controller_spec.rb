require 'rails_helper'

RSpec.describe Steps::Caution::IsDateKnownController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Caution::IsDateKnownForm, CautionDecisionTree
end
