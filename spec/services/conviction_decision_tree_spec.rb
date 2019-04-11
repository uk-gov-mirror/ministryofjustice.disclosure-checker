require 'rails_helper'

RSpec.describe ConvictionDecisionTree do
  let(:disclosure_check) do
    instance_double(DisclosureCheck, known_conviction_date: known_conviction_date,
                                     conviction_type: conviction_type)
  end

  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }
  let(:known_conviction_date) { nil }
  let(:conviction_type) { nil }

  subject { described_class.new(disclosure_check: disclosure_check, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  context 'when the step  `known_conviction_date` equal yes' do
    let(:known_conviction_date) { GenericYesNo::YES }
    let(:step_params) { { known_conviction_date: known_conviction_date} }
    it { is_expected.to have_destination(:conviction_date, :edit) }
  end

  context 'when the step `known_conviction_date` equal no' do
    let(:known_conviction_date) { GenericYesNo::NO }
    let(:step_params) { { known_conviction_date: known_conviction_date} }
    it { is_expected.to have_destination(:under_age_conviction, :edit) }
  end

  context 'when the step is `under_age_conviction`' do
    let(:step_params) { { under_age_conviction: 'yes' } }
    it { is_expected.to have_destination(:conviction_type, :edit) }
  end

  context 'when the step is `under_age_conviction` equal no' do
    let(:step_params) { { under_age_conviction: 'no' } }
    it { is_expected.to have_destination(:conviction_type, :edit) }
  end

  context 'when the step is `conviction_date` ' do
    let(:step_params) { { conviction_date: 'anything' } }
    it { is_expected.to have_destination(:under_age_conviction, :edit) }
  end

  context 'when the step is `conviction_type` equal community_sentence' do
    let(:step_params) { { conviction_type: 'community_sentence' } }
    it { is_expected.to have_destination(:community_order, :edit) }
  end

  context 'when the step is `conviction_type` equal community_sentence' do
    let(:step_params) { { conviction_type: 'custodial_sentence' } }
    it { is_expected.to have_destination(:custodial_sentence, :edit) }
  end

  context 'when the step is `conviction_type`' do
    let(:step_params) { { conviction_type: 'anything' } }
    it { is_expected.to have_destination(:exit, :show) }
  end

  context 'when the step is `community_order`' do
    let(:step_params) { { community_order: 'anything' } }
    it { is_expected.to have_destination(:exit, :show) }
  end

  context 'when the step is `custodial_sentence`' do
    let(:step_params) { { custodial_sentence: 'anything' } }
    it { is_expected.to have_destination(:exit, :show) }
  end

  context 'when the step is `exit`' do
    let(:step_params) { { exit: 'anything' } }
    it { is_expected.to have_destination(:exit, :show) }
  end
end
