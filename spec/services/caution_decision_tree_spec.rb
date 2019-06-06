require 'rails_helper'

RSpec.describe CautionDecisionTree do
  let(:disclosure_check) do
    instance_double(
      DisclosureCheck,
      caution_type: caution_type,
      condition_complied: condition_complied,
      is_date_known: is_date_known,
    )
  end

  let(:caution_type) { nil }
  let(:condition_complied) { nil }
  let(:is_date_known) { nil }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }

  subject { described_class.new(disclosure_check: disclosure_check, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  context 'when the step  `is_date_known` equal yes' do
    let(:is_date_known) { GenericYesNo::YES }
    let(:step_params) { { is_date_known: is_date_known} }
    it { is_expected.to have_destination(:known_date, :edit) }
  end

  context 'when the step  `is_date_known` equal no' do
    let(:is_date_known) { GenericYesNo::NO }
    let(:step_params) { { is_date_known: is_date_known} }
    it { is_expected.to have_destination(:under_age, :edit) }
  end

  context 'when the step is `caution_date`' do
    let(:step_params) { { known_date: 'anything' } }
    it { is_expected.to have_destination(:under_age, :edit) }
  end

  context 'when the step is `under_age`' do
    let(:step_params) { { under_age: 'yes' } }
    it { is_expected.to have_destination(:caution_type, :edit) }
  end

  context 'when the step is `caution_type` does not equal conditional' do
    let(:caution_type)  { CautionType::SIMPLE_CAUTION }
    let(:step_params) { { caution_type: caution_type } }
    it { is_expected.to have_destination(:result, :show) }
  end

  context 'when the step is `caution_type` is equal to conditional' do
    let(:caution_type)  { CautionType::CONDITIONAL_CAUTION }
    let(:step_params) { { caution_type: caution_type } }
    it { is_expected.to have_destination(:conditional_end_date, :edit) }
  end

  context 'when the step is `conditional_end_date`' do
    let(:step_params) { { conditional_end_date: 'conditional' } }
    it { is_expected.to have_destination(:condition_complied, :edit) }
  end

  context 'when the step is `condtion_complied` is equal to `yes`' do
    let(:condition_complied) { GenericYesNo::YES }
    let(:step_params) { { condition_complied: condition_complied} }
    it { is_expected.to have_destination(:result, :show) }
  end

  context 'when the step is `condtion_complied` is equal to `no`' do
    let(:condition_complied) { GenericYesNo::NO }
    let(:step_params) { { condition_complied: condition_complied} }
    it { is_expected.to have_destination(:condition_exit, :show) }
  end
end
