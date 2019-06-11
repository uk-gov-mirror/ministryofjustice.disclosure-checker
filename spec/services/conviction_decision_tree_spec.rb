require 'rails_helper'

RSpec.describe ConvictionDecisionTree do
  let(:disclosure_check) do
    instance_double(
      DisclosureCheck,
      under_age: under_age,
      conviction_type: conviction_type,
    )
  end

  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:under_age)        { nil }
  let(:as)               { nil }
  let(:is_date_known)    { nil }
  let(:conviction_type)  { nil }

  subject { described_class.new(disclosure_check: disclosure_check, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  context 'when the step is `under_age_conviction`' do
    let(:under_age)  { GenericYesNo::YES }
    let(:step_params) { { under_age: under_age } }
    it { is_expected.to have_destination(:conviction_type, :edit) }
  end

  context 'when the step is `under_age_conviction` equal no' do
    let(:under_age)  { GenericYesNo::NO }
    let(:step_params) { { under_age: under_age } }
    it { is_expected.to have_destination(:exit, :show) }
  end

  context 'when the step is `conviction_type`' do
    let(:step_params) { { conviction_type: type } }

    context 'and type has children subtypes' do
      let(:type) { 'community_order' }
      it { is_expected.to have_destination(:conviction_subtype, :edit) }
    end

    context 'and type has no children subtypes' do
      let(:type) { 'hospital_order' }
      it { is_expected.to have_destination(:conviction_end_date, :edit) }
    end
  end

  context 'when the step is `conviction_subtype`' do
    let(:step_params) { { conviction_subtype: 'anything' } }
    it { is_expected.to have_destination(:conviction_end_date, :edit) }
  end

  context 'when the step is `conviction_end_date`' do
    let(:step_params) { { conviction_end_date: 'anything' } }
    it { is_expected.to have_destination('/steps/check/results', :show) }
  end
end
