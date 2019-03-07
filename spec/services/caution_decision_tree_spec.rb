require 'rails_helper'

RSpec.describe CautionDecisionTree do
  let(:disclosure_check) { instance_double(DisclosureCheck) }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }

  subject { described_class.new(disclosure_check: disclosure_check, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  context 'when the step is `caution_date`' do
    let(:step_params) { { caution_date: 'anything' } }
    it { is_expected.to have_destination(:under_age, :edit) }
  end

  context 'when the step is `under_age`' do
    let(:step_params) { { under_age: 'yes' } }
    it { is_expected.to have_destination('/home', :index) }
  end
end
