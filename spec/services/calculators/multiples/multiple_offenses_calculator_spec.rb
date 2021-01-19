require 'rails_helper'

RSpec.describe Calculators::Multiples::MultipleOffensesCalculator do
  subject { described_class.new(disclosure_report) }

  let(:disclosure_report) { instance_double(DisclosureReport, check_groups: groups_result_set) }
  let(:groups_result_set) { double('groups_result_set', with_completed_checks: [check_group1, check_group2]) }

  let(:check_group1) { instance_double(CheckGroup, id: '100', disclosure_checks: %w(a b c)) }
  let(:check_group2) { instance_double(CheckGroup, id: '200', disclosure_checks: %w(a)) }

  before do
    subject.process!
  end

  context '#process!' do
    it 'adds to the results the check groups having more than one disclosure check' do
      expect(subject.results['100']).to be_kind_of(Calculators::Multiples::SameProceedings)
    end

    it 'adds to the results the check groups having only one disclosure check' do
      expect(subject.results['200']).to be_kind_of(Calculators::Multiples::SeparateProceedings)
    end
  end

  context '#spent_date_for' do
    before do
      BaseMultiplesCalculator.subclasses.each do |klass|
        allow_any_instance_of(klass).to receive(:spent_date).and_return("date_#{klass}")
      end
    end

    it 'returns the spent date for the matching check group' do
      expect(subject.spent_date_for(check_group1)).to eq('date_Calculators::Multiples::SameProceedings')
      expect(subject.spent_date_for(check_group2)).to eq('date_Calculators::Multiples::SeparateProceedings')
    end

    it 'returns nil if no date was found' do
      group = double('group', id: 'foobar')
      expect(subject.spent_date_for(group)).to be_nil
    end
  end

  describe '#all_spent?' do
    before do
      BaseMultiplesCalculator.subclasses.each do |klass|
        allow_any_instance_of(klass).to receive(:spent_date).and_return(*spent_dates)
      end
    end

    context 'when there is an offence that will never be spent' do
      let(:spent_dates) { [ResultsVariant::NEVER_SPENT, Date.yesterday] }

      it 'returns false' do
        expect(subject.all_spent?).to eq(false)
      end
    end

    context 'when there is an offence with `spent_simple`' do
      let(:spent_dates) { [Date.yesterday, ResultsVariant::SPENT_SIMPLE] }

      it 'considers the spent_simple as spent' do
        expect(subject.all_spent?).to eq(true)
      end
    end

    context 'when there is an offence with `indefinite`' do
      let(:spent_dates) { [ResultsVariant::INDEFINITE, Date.tomorrow] }

      it 'excludes the `indefinite` offence, and check the other dates' do
        expect(subject.all_spent?).to eq(false)
      end
    end

    context 'when there are dates' do
      let(:spent_dates) { [Date.yesterday, Date.tomorrow] }

      it 'checks if all the dates are in the past' do
        expect(subject.all_spent?).to eq(false)
      end
    end

    context 'when there are dates' do
      let(:spent_dates) { [Date.yesterday, Date.yesterday-3.days] }

      it 'checks if all the dates are in the past' do
        expect(subject.all_spent?).to eq(true)
      end
    end
  end
end
