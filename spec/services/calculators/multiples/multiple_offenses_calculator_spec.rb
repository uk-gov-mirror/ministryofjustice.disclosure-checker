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
  end
end
