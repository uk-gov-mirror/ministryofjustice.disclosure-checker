require 'rails_helper'

RSpec.describe <%= task_name.camelize %>DecisionTree do
  let(:disclosure_check) { instance_double(DisclosureCheck) }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }

  subject { described_class.new(disclosure_check: disclosure_check, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  pending 'Write specs for <%= task_name.camelize %>DecisionTree!'

  # TODO: The below can be uncommented and serves as a starting point

  # context 'when the step is `user_type`' do
  #   let(:step_params) { { user_type: 'anything' } }
  #
  #   context 'and the answer is `themself`' do
  #     let(:disclosure_check) { instance_double(DisclosureCheck, user_type: UserType::THEMSELF) }
  #     it { is_expected.to have_destination(:user_type, :edit) }
  #   end
  #
  #   context 'and the answer is `representative`' do
  #     let(:disclosure_check) { instance_double(DisclosureCheck, user_type: UserType::REPRESENTATIVE) }
  #     it { is_expected.to have_destination(:user_type, :edit) }
  #   end
  # end
end
