require 'rails_helper'

RSpec.describe CheckDecisionTree do
  let(:disclosure_check) do
    instance_double(
      DisclosureCheck,
      kind: kind,
      under_age: under_age,
    )
  end

  let(:step_params)      { double('Step') }
  let(:next_step)        { nil }
  let(:as)               { nil }
  let(:kind)             { nil }
  let(:under_age)        { nil }

  let(:multiples_enabled) { false }

  subject {
    described_class.new(
      disclosure_check: disclosure_check, step_params: step_params, as: as, next_step: next_step, multiples_enabled: multiples_enabled
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
end
