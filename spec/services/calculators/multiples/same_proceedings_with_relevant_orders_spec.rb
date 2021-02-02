require 'rails_helper'

RSpec.describe Calculators::Multiples::MultipleOffensesCalculator do
  subject { described_class.new(disclosure_report) }

  let(:disclosure_report) { DisclosureReport.new }
  let(:check_group) { disclosure_report.check_groups.build }

  def save_report
    disclosure_report.completed!
  end

  context 'when same proceedings' do
    let(:same_proceedings) { subject.results[check_group.id] }

    context 'when both convictions are relevant orders' do
      before do
        check_group.disclosure_checks << build(:disclosure_check, :adult, :with_discharge_order, :completed, known_date: Date.new(2000, 1, 1), conviction_length: 36)
        check_group.disclosure_checks << build(:disclosure_check, :adult, :with_motoring_disqualification, :completed, known_date: Date.new(2000, 1, 1))
        save_report
      end

      it 'the longest date is the spent date' do
        expect(subject.spent_date_for(same_proceedings)).to eq(Date.new(2003, 1, 1))
      end
    end

    # TODO: This needs confirmation, please visit the following card https://trello.com/c/sZ7qBDwe/
    context 'when a relevant order is the longest sentence' do
      before do
        check_group.disclosure_checks << build(:disclosure_check, :adult, :with_discharge_order, :completed, known_date: Date.new(2000, 1, 1), conviction_length: 48)
        check_group.disclosure_checks << build(:disclosure_check, :adult, :with_discharge_order, :completed, known_date: Date.new(2000, 1, 1), conviction_length: 36)
        check_group.disclosure_checks << build(:disclosure_check, :adult, :with_motoring_fine, :completed, known_date: Date.new(2000, 1, 1))
        save_report
      end

      it 'ignores the relevant order' do
        expect(subject.spent_date_for(same_proceedings)).to eq(Date.new(2001, 1, 1))
      end
    end

    context 'conviction length' do
      context 'when two convictions have different conviction length types' do
        before do
          check_group.disclosure_checks << build(:disclosure_check, :adult, :with_discharge_order, :completed, known_date: Date.new(2000, 6, 1), conviction_length: 12, conviction_length_type: ConvictionLengthType::MONTHS)
          check_group.disclosure_checks << build(:disclosure_check, :adult, :with_discharge_order, :completed, known_date: Date.new(2000, 6, 1), conviction_length: 12, conviction_length_type: ConvictionLengthType::WEEKS)
          check_group.disclosure_checks << build(:disclosure_check, :adult, :with_motoring_fine, :completed, known_date: Date.new(2000, 1, 1), conviction_length: 3, conviction_length_type: ConvictionLengthType::MONTHS)
          save_report
        end

        it 'distinguishes between different conviction length types' do
          expect(subject.spent_date_for(same_proceedings)).to eq(Date.new(2001, 1, 1))
        end
      end

      context 'when there is a conviction with `length not given`' do
        context 'when all sentences are relevant orders' do
          before do
            check_group.disclosure_checks << build(:disclosure_check, :adult, :with_discharge_order, :completed, known_date: Date.new(2000, 6, 1), conviction_length: nil, conviction_length_type: ConvictionLengthType::NO_LENGTH)
            check_group.disclosure_checks << build(:disclosure_check, :adult, :with_discharge_order, :completed, known_date: Date.new(2000, 1, 1), conviction_length: 12, conviction_length_type: ConvictionLengthType::WEEKS)
            save_report
          end

          it 'calculates the expiry date as 24 months later' do
            expect(subject.spent_date_for(same_proceedings)).to eq(Date.new(2002, 6, 1))
          end
        end

        context 'when not all sentences are relevant orders' do
          before do
            check_group.disclosure_checks << build(:disclosure_check, :adult, :with_discharge_order, :completed, known_date: Date.new(2000, 12, 1), conviction_length: nil, conviction_length_type: ConvictionLengthType::NO_LENGTH)
            check_group.disclosure_checks << build(:disclosure_check, :adult, :with_motoring_fine, :completed, known_date: Date.new(2000, 1, 1))
            save_report
          end

          it 'ignores the relevant order date' do
            expect(subject.spent_date_for(same_proceedings)).to eq(Date.new(2001, 1, 1))
          end
        end
      end

      context 'when there is a conviction with an `indefinite`' do
        context 'and the indefinite sentence is a relevant order (scenario 2 from nacro)' do
          before do
            check_group.disclosure_checks << build(:disclosure_check, :adult, :with_prison_sentence, :completed, known_date: Date.new(2011, 6, 10), conviction_date: Date.new(2011, 6, 10), conviction_length: 6, conviction_length_type: ConvictionLengthType::MONTHS)
            check_group.disclosure_checks << build(:disclosure_check, :adult, :with_restraining_order, :completed, known_date: Date.new(2011, 6, 10), conviction_date: Date.new(2011, 6, 10), conviction_length: nil, conviction_length_type: ConvictionLengthType::INDEFINITE)
            check_group.disclosure_checks << build(:disclosure_check, :adult, :with_fine, :completed, known_date: Date.new(2011, 6, 10), conviction_date: Date.new(2011, 6, 10))

            save_report
          end

          it 'returns indefinite' do
            expect(subject.spent_date_for(same_proceedings)).to eq(ResultsVariant::INDEFINITE)
          end
        end

        context 'when all sentences are relevant orders' do
          before do
            check_group.disclosure_checks << build(:disclosure_check, :adult, :with_discharge_order, :completed, known_date: Date.new(2000, 6, 1), conviction_length: nil, conviction_length_type: ConvictionLengthType::INDEFINITE)
            check_group.disclosure_checks << build(:disclosure_check, :adult, :with_discharge_order, :completed, known_date: Date.new(2000, 1, 1), conviction_length: 12, conviction_length_type: ConvictionLengthType::WEEKS)
            save_report
          end

          it 'returns indefinite' do
            expect(subject.spent_date_for(same_proceedings)).to eq(ResultsVariant::INDEFINITE)
          end
        end

        context 'when not all sentences are relevant orders' do
          before do
            check_group.disclosure_checks << build(:disclosure_check, :adult, :with_discharge_order, :completed, known_date: Date.new(2000, 6, 1), conviction_length: nil, conviction_length_type: ConvictionLengthType::INDEFINITE)
            check_group.disclosure_checks << build(:disclosure_check, :adult, :with_motoring_fine, :completed, known_date: Date.new(2000, 1, 1))
            save_report
          end

          # TODO: This needs to be confirmed, visit the following card https://trello.com/c/sZ7qBDwe/
          it 'ignores the relevant order indefinite date' do
            expect(subject.spent_date_for(same_proceedings)).to eq(Date.new(2001, 1, 1))
          end
        end
      end
    end
  end
end
