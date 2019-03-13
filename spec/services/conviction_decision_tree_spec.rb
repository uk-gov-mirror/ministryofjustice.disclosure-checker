require 'rails_helper'

RSpec.describe ConvictionDecisionTree do
  let(:disclosure_check) { instance_double(DisclosureCheck) }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }

  subject { described_class.new(disclosure_check: disclosure_check, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  context 'when the step is `exit`' do
    let(:step_params) { { exit: 'anything' } }
    it { is_expected.to have_destination(:exit, :show) }
  end
end
