require 'rails_helper'

RSpec.describe CheckDecisionTree do
  let(:disclosure_check) do
    instance_double(
      DisclosureCheck,
      kind: kind,
      under_age: under_age,
    )
  end

  let(:controller)       { double('controller', multiples_enabled?: multiples_enabled) }
  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }
  let(:kind)             { nil }
  let(:under_age)        { nil }

  let(:multiples_enabled) { false }

  subject {
    described_class.new(
      disclosure_check: disclosure_check, step_params: step_params, as: as, next_step: next_step, controller: controller
    )
  }

  it_behaves_like 'a decision tree'

  context 'when the step is `kind`' do
    let(:step_params) { { kind: 'whatever' } }
    it { is_expected.to have_destination(:under_age, :edit) }
  end

  describe 'when the step is `under_age`' do
    let(:step_params) { { under_age: under_age } }

    context 'and answer is `no`' do
      let(:under_age) { GenericYesNo::NO }

      context 'for a caution check' do
        let(:kind) { 'caution' }
        it { is_expected.to have_destination('/steps/caution/caution_type', :edit) }
      end

      context 'for a conviction check' do
        let(:kind) { 'conviction' }

        context 'and multiples MVP is enabled' do
          let(:multiples_enabled) { true }
          it { is_expected.to have_destination('/steps/conviction/conviction_date', :edit) }
        end

        context 'and multiples MVP is disabled' do
          it { is_expected.to have_destination('/steps/conviction/conviction_type', :edit) }
        end
      end
    end

    context 'and answer is `yes`' do
      let(:under_age) { GenericYesNo::YES }

      context 'for a caution check' do
        let(:kind) { 'caution' }
        it { is_expected.to have_destination('/steps/caution/caution_type', :edit) }
      end

      context 'for a conviction check' do
        let(:kind) { 'conviction' }
        it { is_expected.to have_destination('/steps/conviction/conviction_type', :edit) }
      end
    end
  end

  describe 'when the step is `add_caution_or_conviction`' do
    let(:step_params) { { add_caution_or_conviction: add_caution_or_conviction } }

    context 'and answer is `yes`' do
      let(:add_caution_or_conviction) { GenericYesNo::YES }

      before do
        allow(disclosure_check).to receive(:disclosure_report).and_return('disclosure_report')
        allow(controller).to receive(:initialize_disclosure_check).with(disclosure_report: 'disclosure_report')
      end

      it {is_expected.to have_destination(:kind, :edit) }
    end

    context 'and answer is `no`' do
      let(:add_caution_or_conviction) { GenericYesNo::NO }

      it { expect(subject.destination).to eq({controller: :results, action: :show, show_results: true}) }
    end
  end
end
