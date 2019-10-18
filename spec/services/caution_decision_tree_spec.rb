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

  context 'when the step is `caution_type`' do
    let(:step_params) { { caution_type: 'anything' } }
    it { is_expected.to have_destination(:known_date, :edit) }
  end

  describe 'when the step is `known_date`' do
    let(:step_params) { { known_date: 'anything' } }

    context 'and type is `simple caution`' do
      let(:caution_type) { CautionType::ADULT_SIMPLE_CAUTION }
      it { is_expected.to complete_the_check_and_show_results }
    end

    context 'and type is `conditional caution`' do
      let(:caution_type)  { CautionType::ADULT_CONDITIONAL_CAUTION }
      it { is_expected.to have_destination(:conditional_end_date, :edit) }
    end
  end

  context 'when the step is `conditional_end_date`' do
    let(:step_params) { { conditional_end_date: 'conditional' } }
    it { is_expected.to complete_the_check_and_show_results }
  end
end
