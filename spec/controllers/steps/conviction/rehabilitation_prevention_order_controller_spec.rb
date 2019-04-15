require 'rails_helper'

RSpec.describe Steps::Conviction::RehabilitationPreventionOrderController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Conviction::RehabilitationPreventionOrderForm, ConvictionDecisionTree
end
