require 'rails_helper'

RSpec.describe CheckDecisionTree do
  let(:disclosure_check) { instance_double(DisclosureCheck) }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }

  subject { described_class.new(disclosure_check: disclosure_check, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  context 'when the step is `kind`' do
    let(:step_params) { { kind: 'anything' } }
    it { is_expected.to have_destination(:caution_date, :edit) }
  end

  context 'when the step is `caution_date`' do
    let(:step_params) { { caution_date: 'anything' } }
    it { is_expected.to have_destination('/home', :index) }
  end
end
