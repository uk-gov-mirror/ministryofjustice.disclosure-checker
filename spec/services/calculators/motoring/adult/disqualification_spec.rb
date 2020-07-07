require 'rails_helper'

RSpec.describe Calculators::Motoring::Adult::Disqualification do
  subject { described_class.new(disclosure_check) }

  let(:disclosure_check) { build(:disclosure_check,
                                 under_age: under_age,
                                 known_date: known_date,
                                 motoring_endorsement: motoring_endorsement,
                                 motoring_disqualification_end_date: motoring_disqualification_end_date) }

  let(:under_age) { GenericYesNo::NO }
  let(:known_date) { Date.new(2018, 10, 31) }
  let(:motoring_endorsement) { GenericYesNo::NO }
  let(:motoring_disqualification_end_date) { Date.new(2020, 10, 31) }

  describe '#expiry_date' do
    context 'with a motoring_disqualification_end_date' do
      context 'with a motoring endorsement ' do
        let(:motoring_endorsement) { GenericYesNo::YES }

        context 'less than or equal 5 years' do
          it { expect(subject.expiry_date.to_s).to eq('2023-10-31') }
        end

        context 'greater than 5 years' do
          let(:motoring_disqualification_end_date) { Date.new(2025, 10, 31) }
          it { expect(subject.expiry_date.to_s).to eq(motoring_disqualification_end_date.to_s) }
        end
      end

      context 'without a motoring endorsement ' do
        it { expect(subject.expiry_date.to_s).to eq(motoring_disqualification_end_date.to_s) }
      end
    end

    context 'without a motoring_disqualification_end_date' do
      let(:motoring_disqualification_end_date) { nil }
      context 'with a motoring endorsement ' do
        let(:motoring_endorsement) { GenericYesNo::YES }
        it { expect(subject.expiry_date.to_s).to eq('2023-10-31') }
      end

      context 'without a motoring endorsement ' do
        it { expect(subject.expiry_date.to_s).to eq('2020-10-31') }
      end
    end
  end
end
