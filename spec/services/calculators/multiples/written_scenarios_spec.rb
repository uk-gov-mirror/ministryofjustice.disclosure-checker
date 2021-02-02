require 'rails_helper'

RSpec.describe Calculators::Multiples::MultipleOffensesCalculator do
  subject { described_class.new(disclosure_report) }

  let(:disclosure_report) { DisclosureReport.new }
  let(:first_proceeding_group) { disclosure_report.check_groups.build }
  let(:second_proceeding_group) { disclosure_report.check_groups.build }

  let(:first_proceedings) { subject.results[first_proceeding_group.id] }
  let(:second_proceedings) { subject.results[second_proceeding_group.id] }

  def save_report
    disclosure_report.completed!
  end

  context 'two separate convictions' do
    context 'scenario 1' do
      # Scenario 1
      # Adult person was convicted of assault on 1 August 2009 and received:
      # - a 3 month suspended sentence (This would become spent on 1 November 2011.)
      #
      # On 10 June 2011, he was convicted of battery and sentenced to:
      # - a 6 month custodial sentence
      # - a restraining order until further notice
      # - a fine for £50
      #
      # The 2011 conviction would remain unspent until further notice, due to the restraining order.
      # Their first conviction in 2009 would will be extended until 10 December 2013
      # due to the custodial sentence they received in the 10 June 2011.
      # However, the rehabilitation period would not be affected by the restraining order.

      let(:first_conviction_date) { Date.new(2009, 8, 1) }
      let(:second_conviction_date) { Date.new(2011, 6, 10) }
      let(:expected_first_conviction_spent_date) { Date.new(2013, 12, 10) }
      let(:expected_second_conviction_spent_date) { ResultsVariant::INDEFINITE }

      let(:suspended_prison_sentence) do
        build(
          :disclosure_check,
          :suspended_prison_sentence,
          :completed,
          known_date: first_conviction_date,
          conviction_date: first_conviction_date,
          conviction_length: 3
        )
      end

      let(:custodial_sentence) do
        build(
          :disclosure_check,
          :with_prison_sentence,
          :completed,
          known_date: second_conviction_date,
          conviction_date: second_conviction_date,
          conviction_length: 6
        )
      end

      let(:restraining_order) do
        build(
          :disclosure_check,
          :with_restraining_order,
          :completed,
          known_date: second_conviction_date,
          conviction_date: second_conviction_date,
          conviction_length: nil,
          conviction_length_type: ConvictionLengthType::INDEFINITE
        )
      end

      let(:financial_fine) do
        build(
          :disclosure_check,
          :adult,
          :with_fine,
          :completed,
          known_date: second_conviction_date,
          conviction_date: second_conviction_date
        )
      end

      before do
        first_proceeding_group.disclosure_checks << suspended_prison_sentence
        second_proceeding_group.disclosure_checks << custodial_sentence
        second_proceeding_group.disclosure_checks << restraining_order
        second_proceeding_group.disclosure_checks << financial_fine

        save_report
      end

      it 'returns the date for the first proceeeding' do
        expect(subject.spent_date_for(first_proceedings)).to eq(expected_first_conviction_spent_date)
      end

      it 'returns indefinite for the second proceeding' do
        expect(subject.spent_date_for(second_proceedings)).to eq(expected_second_conviction_spent_date)
      end
    end
  end
end
