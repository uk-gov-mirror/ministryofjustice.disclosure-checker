require 'rails_helper'

RSpec.describe ConvictionDecisionTree do
  let(:disclosure_check) { instance_double(DisclosureCheck, known_conviction_date: known_conviction_date) }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }
  let(:known_conviction_date) { nil }

  subject { described_class.new(disclosure_check: disclosure_check, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  context 'when the step  `known_conviction_date` equal yes' do
    let(:known_conviction_date) { GenericYesNo::YES }
    let(:step_params) { { known_conviction_date: known_conviction_date} }
    it { is_expected.to have_destination(:exit, :show) }
  end

  context 'when the step `known_conviction_date` equal no' do
    let(:known_conviction_date) { GenericYesNo::NO }
    let(:step_params) { { known_conviction_date: known_conviction_date} }
    it { is_expected.to have_destination(:under_age_conviction, :edit) }
  end

  context 'when the step is `under_age_conviction`' do
    let(:step_params) { { under_age_conviction: 'yes' } }
    it { is_expected.to have_destination(:exit, :show) }
  end

  context 'when the step is `under_age_conviction` equal no' do
    let(:step_params) { { under_age_conviction: 'no' } }
    it { is_expected.to have_destination(:exit, :show) }
  end

  context 'when the step is `exit`' do
    let(:step_params) { { exit: 'anything' } }
    it { is_expected.to have_destination(:exit, :show) }
  end
end
