require 'rails_helper'

RSpec.describe CheckDecisionTree do
  let(:disclosure_check) { instance_double(DisclosureCheck) }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }

  subject { described_class.new(disclosure_check: disclosure_check, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  context 'when the step is `kind`' do
    let(:step_params) { { kind: kind } }

    context 'and the answer is `caution`' do
      let(:kind) { 'caution' }
      it { is_expected.to have_destination('/steps/caution/known_caution_date', :edit) }
    end

    context 'and the answer is `conviction`' do
      let(:kind) { 'conviction' }
      it { is_expected.to have_destination('/steps/conviction/exit', :show) }
    end
  end
end
