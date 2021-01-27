require 'rails_helper'

RSpec.describe Calculators::Multiples::MultipleOffensesCalculator do
  subject { described_class.new(disclosure_report) }

  let(:disclosure_report) { instance_double(DisclosureReport, check_groups: groups_result_set, completed?: true) }
  let(:groups_result_set) { double('groups_result_set', with_completed_checks: [check_group1, check_group2]) }

  let(:check_group1) { instance_double(CheckGroup, id: '100', disclosure_checks: [disclosure_check1, disclosure_check2]) }
  let(:check_group2) { instance_double(CheckGroup, id: '200', disclosure_checks: [disclosure_check3]) }

  let(:disclosure_check1) { instance_double(DisclosureCheck, kind: 'conviction') }
  let(:disclosure_check2) { instance_double(DisclosureCheck, kind: 'conviction') }
  let(:disclosure_check3) { instance_double(DisclosureCheck, kind: 'caution') }

  let(:same_proceedings) { subject.results[check_group1.id] }
  let(:separate_proceedings) { subject.results[check_group2.id] }

  before do
    # Note: because these are doubles, the method does not work, so we emulate it
    allow(check_group1).to receive(:multiple_sentences?).and_return(check_group1.disclosure_checks.size > 1)
    allow(check_group2).to receive(:multiple_sentences?).and_return(check_group2.disclosure_checks.size > 1)
  end

  context '#process!' do
    it 'adds to the results the check groups having more than one disclosure check' do
      expect(same_proceedings).to be_kind_of(Calculators::Multiples::SameProceedings)
    end

    it 'adds to the results the check groups having only one disclosure check' do
      expect(separate_proceedings).to be_kind_of(Calculators::Multiples::SeparateProceedings)
    end
  end

  describe '#spent_date_for' do
    context 'conviction with 2 sentences, and one simple caution' do
      let(:disclosure_check1) { build(:disclosure_check, :dto_conviction) }
      let(:disclosure_check2) { build(:disclosure_check, :suspended_prison_sentence) }
      let(:disclosure_check3) { build(:disclosure_check, :youth_simple_caution) }

      it 'returns the spent date for the matching check group' do
        expect(subject.spent_date_for(same_proceedings)).to eq(Date.new(2024, 01, 30))
        expect(subject.spent_date_for(separate_proceedings)).to eq(ResultsVariant::SPENT_SIMPLE)
      end
    end

    context 'conviction with 2 sentences, and another, separate proceedings conviction' do
      let(:disclosure_check1) { build(:disclosure_check, :dto_conviction) }
      let(:disclosure_check2) { build(:disclosure_check, :suspended_prison_sentence) }

      context 'all sentences are dates' do
        let(:disclosure_check3) { build(:disclosure_check, :with_prison_sentence) }

        it 'returns the spent date for the matching check group' do
          expect(subject.spent_date_for(same_proceedings)).to eq(Date.new(2024, 1, 30))
          expect(subject.spent_date_for(separate_proceedings)).to eq(Date.new(2024, 1, 30))
        end
      end

      context 'one of the sentences has indefinite length' do
        let(:disclosure_check3) { build(:disclosure_check, :with_motoring_disqualification, conviction_length_type: 'indefinite') }

        it 'returns the spent date for the matching check group' do
          expect(subject.spent_date_for(same_proceedings)).to eq(ResultsVariant::INDEFINITE)
          expect(subject.spent_date_for(separate_proceedings)).to eq(ResultsVariant::INDEFINITE)
        end
      end

      context 'one of the sentences will never be spent' do
        let(:disclosure_check3) { build(:disclosure_check, :with_prison_sentence, conviction_length: 50) }

        it 'returns the spent date for the matching check group' do
          expect(subject.spent_date_for(same_proceedings)).to eq(ResultsVariant::NEVER_SPENT)
          expect(subject.spent_date_for(separate_proceedings)).to eq(ResultsVariant::NEVER_SPENT)
        end
      end
    end
  end

  describe '#all_spent?' do
    before do
      allow(same_proceedings).to receive(:spent_date).and_return(spent_dates[0])
      allow(separate_proceedings).to receive(:spent_date).and_return(spent_dates[1])
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
