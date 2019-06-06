require 'rails_helper'

RSpec.describe ConvictionDecisionTree do
  let(:disclosure_check) do
    instance_double(
      DisclosureCheck,
      is_date_known: is_date_known,
      conviction_type: conviction_type,
    )
  end

  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }
  let(:is_date_known)    { nil }
  let(:conviction_type)  { nil }

  subject { described_class.new(disclosure_check: disclosure_check, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  context 'when the step  `is_date_known` equal yes' do
    let(:is_date_known) { GenericYesNo::YES }
    let(:step_params) { { is_date_known: is_date_known} }
    it { is_expected.to have_destination(:known_date, :edit) }
  end

  context 'when the step `is_date_known` equal no' do
    let(:is_date_known) { GenericYesNo::NO }
    let(:step_params) { { is_date_known: is_date_known} }
    it { is_expected.to have_destination(:under_age, :edit) }
  end

  context 'when the step is `under_age_conviction`' do
    let(:step_params) { { under_age: 'yes' } }
    it { is_expected.to have_destination(:conviction_type, :edit) }
  end

  context 'when the step is `under_age_conviction` equal no' do
    let(:step_params) { { under_age: 'no' } }
    it { is_expected.to have_destination(:conviction_type, :edit) }
  end

  context 'when the step is `conviction_date` ' do
    let(:step_params) { { known_date: 'anything' } }
    it { is_expected.to have_destination(:under_age, :edit) }
  end

  context 'when the step is `conviction_type`' do
    let(:step_params) { { conviction_type: type } }

    context 'and type is `anything`' do
      let(:type) { 'anything' }
      it { is_expected.to have_destination(:exit, :show) }
    end

    context 'and type is `community_order`' do
      let(:type) { 'community_order' }
      it { is_expected.to have_destination(:community_order, :edit) }
    end

    context 'and type is `custodial_sentence`' do
      let(:type) { 'custodial_sentence' }
      it { is_expected.to have_destination(:custodial_sentence, :edit) }
    end

    context 'and type is `discharge`' do
      let(:type) { 'discharge' }
      it { is_expected.to have_destination(:discharge, :edit) }
    end

    context 'and type is `financial`' do
      let(:type) { 'financial' }
      it { is_expected.to have_destination(:financial, :edit) }
    end

    context 'and type is `hospital_order`' do
      let(:type) { 'hospital_order' }
      it { is_expected.to have_destination(:conviction_end_date, :edit) }
    end

    context 'and type is `military`' do
      let(:type) { 'military' }
      it { is_expected.to have_destination(:military, :edit) }
    end

    context 'and type is `motoring`' do
      let(:type) { 'motoring' }
      it { is_expected.to have_destination(:motoring, :edit) }
    end

    context 'and type is `rehabilitation_prevention' do
      let(:type) { 'rehabilitation_prevention_order' }
      it { is_expected.to have_destination(:rehabilitation_prevention_order, :edit) }
    end
  end

  context 'when the step is `community_order`' do
    let(:step_params) { { community_order: 'anything' } }
    it { is_expected.to have_destination(:conviction_end_date, :edit) }
  end

  context 'when the step is `custodial_sentence`' do
    let(:step_params) { { custodial_sentence: 'anything' } }
    it { is_expected.to have_destination(:conviction_end_date, :edit) }
  end

  context 'when the step is `discharge`' do
    let(:step_params) { { discharge: 'absolute_discharge' } }
    it { is_expected.to have_destination(:conviction_end_date, :edit) }
  end

  context 'when the step is `financial`' do
    let(:step_params) { { financial: 'anything' } }
    it { is_expected.to have_destination(:conviction_end_date, :edit) }
  end

  context 'when the step is `military`' do
    let(:step_params) { { military: 'anything' } }
    it { is_expected.to have_destination(:conviction_end_date, :edit) }
  end

  context 'when the step is `motoring`' do
    let(:step_params) { { motoring: 'anything' } }
    it { is_expected.to have_destination(:conviction_end_date, :edit) }
  end

  context 'when the step is `rehabilitation_prevention_order`' do
    let(:step_params) { { rehabilitation_prevention_order: 'anything' } }
    it { is_expected.to have_destination(:conviction_end_date, :edit) }
  end

  context 'when the step is `conviction_end_date`' do
    let(:step_params) { { conviction_end_date: 'anything' } }
    it { is_expected.to have_destination(:exit, :show) }
  end

  context 'when the step is `exit`' do
    let(:step_params) { { exit: 'anything' } }
    it { is_expected.to have_destination(:exit, :show) }
  end
end
