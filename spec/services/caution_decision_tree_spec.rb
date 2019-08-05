require 'rails_helper'

RSpec.describe CautionDecisionTree do
  let(:disclosure_check) do
    instance_double(
      DisclosureCheck,
      caution_type: caution_type,
      under_age: under_age,
    )
  end

  let(:caution_type) { nil }
  let(:under_age)    { nil }
  let(:step_params)  { double('Step') }
  let(:next_step)    { nil }
  let(:as)           { nil }

  subject { described_class.new(disclosure_check: disclosure_check, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  describe 'when the step is `under_age`' do
    let(:step_params) { { under_age: under_age } }

    context 'and answer is `yes`' do
      let(:under_age) { GenericYesNo::YES }
      it { is_expected.to have_destination(:caution_type, :edit) }
    end

    context 'and answer is `no`' do
      let(:under_age) { GenericYesNo::NO }
      it { is_expected.to have_destination('/steps/check/exit_over18', :show) }
    end

    # TODO: temporary feature-flag, to be removed when no needed
    context 'and answer is `no` but we are bypassing' do
      let(:under_age) { GenericYesNo::NO }
      let(:as) { :bypass_under_age }
      it { is_expected.to have_destination(:caution_type, :edit) }
    end
  end

  context 'when the step is `caution_type`' do
    let(:step_params) { { caution_type: 'anything' } }
    it { is_expected.to have_destination(:known_date, :edit) }
  end

  describe 'when the step is `known_date`' do
    let(:step_params) { { known_date: 'anything' } }

    context 'and type is `simple caution`' do
      let(:caution_type) { CautionType::SIMPLE_CAUTION }
      it { is_expected.to have_destination('/steps/check/results', :show) }
    end

    context 'and type is `conditional caution`' do
      let(:caution_type)  { CautionType::CONDITIONAL_CAUTION }
      it { is_expected.to have_destination(:conditional_end_date, :edit) }
    end
  end

  context 'when the step is `conditional_end_date`' do
    let(:step_params) { { conditional_end_date: 'conditional' } }
    it { is_expected.to have_destination('/steps/check/results', :show) }
  end
end
