require 'rails_helper'

RSpec.describe Calculators::Multiples::MultipleOffensesCalculator do
  subject { described_class.new(disclosure_report) }

  let(:disclosure_report) { DisclosureReport.new }
  let(:first_group) { disclosure_report.check_groups.build }
  let(:second_group) { disclosure_report.check_groups.build }

  def save_report_and_process_calculation
    disclosure_report.save
    subject.process!
  end

  context 'adult' do
    context 'when same proceedings' do
      context 'when a relevant order is the longest sentence' do
        before do
          first_group.disclosure_checks << FactoryBot.create(:disclosure_check, :adult, :with_discharge_order, :completed, known_date: Date.new(2000, 1, 1), conviction_length: 36)
          first_group.disclosure_checks << FactoryBot.create(:disclosure_check, :adult, :with_motoring_disqualification, :completed, known_date: Date.new(2000, 1, 1))

          save_report_and_process_calculation
        end

        it 'ignores the relevant order' do
          pending
          expect(subject.spent_date_for(first_group)).to eq(Date.new(2000, 7, 1))
        end
      end
    end

    context 'with separate proceedings' do
      context 'two convictions that overlap in time' do
        before do
          first_group.disclosure_checks << FactoryBot.create(:disclosure_check, :adult, :with_discharge_order, :completed, known_date: Date.new(2000, 12, 2))
          second_group.disclosure_checks << FactoryBot.create(:disclosure_check, :adult, :with_fine, :completed, known_date: Date.new(2001, 8, 6))

          save_report_and_process_calculation
        end

        it 'calculates the spent date of the latest date for both convictions' do
          expect(subject.spent_date_for(first_group)).to eq(Date.new(2002, 8, 6))
          expect(subject.spent_date_for(second_group)).to eq(Date.new(2002, 8, 6))
        end
      end

      context 'two convictions that do not overlap in time' do
        before do
          first_group.disclosure_checks << FactoryBot.create(:disclosure_check, :adult, :with_fine, :completed, known_date: Date.new(2000, 1, 1))
          second_group.disclosure_checks << FactoryBot.create(:disclosure_check, :adult, :with_fine, :completed, known_date: Date.new(2005, 5, 5))

          save_report_and_process_calculation
        end

        it 'calculates the spent date of each conviction separately' do
          expect(subject.spent_date_for(first_group)).to eq(Date.new(2001, 1, 1))
          expect(subject.spent_date_for(second_group)).to eq(Date.new(2006, 5, 5))
        end
      end

      context '4 convictions, 2 of them overlap and the other 2 overlap but one is never spent' do
        let(:third_group) { disclosure_report.check_groups.build }
        let(:fourth_group) { disclosure_report.check_groups.build }

        before do
          first_group.disclosure_checks << FactoryBot.create(:disclosure_check, :adult, :with_fine, :completed, known_date: Date.new(2000, 12, 2))
          second_group.disclosure_checks << FactoryBot.create(:disclosure_check, :adult, :with_fine, :completed, known_date: Date.new(2001, 2, 2))

          third_group.disclosure_checks << FactoryBot.create(:disclosure_check, :adult, :with_prison_sentence, :completed, known_date: Date.new(2005, 1, 1), conviction_length: 60)
          fourth_group.disclosure_checks << FactoryBot.create(:disclosure_check, :adult, :with_sexual_harm_order, :completed, known_date: Date.new(2005, 4, 2))

          save_report_and_process_calculation
        end

        it 'calculates the first 2 convictions as the same spent date' do
          expect(subject.spent_date_for(first_group)).not_to eq(ResultsVariant::NEVER_SPENT)

          expect(subject.spent_date_for(first_group)).to eq(subject.spent_date_for(second_group))
          expect(subject.spent_date_for(first_group)).to eq(Date.new(2002, 2, 2))
        end

        it 'calculates the second 2 convictions as never spent' do
          expect(subject.spent_date_for(third_group)).to eq(subject.spent_date_for(fourth_group))
          expect(subject.spent_date_for(first_group)).to eq(ResultsVariant::NEVER_SPENT)
        end
      end
    end
  end
end
