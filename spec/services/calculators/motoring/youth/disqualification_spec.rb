require 'rails_helper'

RSpec.describe Calculators::Motoring::Youth::Disqualification do
  subject { described_class.new(disclosure_check) }

  let(:disclosure_check) { build(:disclosure_check,
                                 under_age: under_age,
                                 known_date: known_date,
                                 motoring_endorsement: motoring_endorsement,
                                 motoring_disqualification_end_date: motoring_disqualification_end_date,
                                 motoring_lifetime_ban: motoring_lifetime_ban) }

  let(:under_age) { GenericYesNo::YES }
  let(:known_date) { Date.new(2018, 10, 31) }
  let(:motoring_endorsement) { GenericYesNo::NO }
  let(:motoring_disqualification_end_date) { Date.new(2020, 10, 31) }
  let(:motoring_lifetime_ban) { nil }

  describe '#expiry_date' do
    context 'with a motoring lifetime ban' do
      let(:motoring_lifetime_ban) { GenericYesNo::YES }
      it { expect(subject.expiry_date).to eq(:never_spent) }
    end

    context 'without a motoring lifetime ban' do
      let(:motoring_lifetime_ban) { GenericYesNo::NO }

      context 'with a motoring_disqualification_end_date' do
        context 'with a motoring endorsement' do
          let(:motoring_endorsement) { GenericYesNo::YES }

          context 'less than or equal to 2.5 years' do
            it { expect(subject.expiry_date.to_s).to eq((known_date + 30.months).to_s) }
          end

          context 'greater than 2.5 years' do
            let(:motoring_disqualification_end_date) { Date.new(2025, 10, 31) }
            it { expect(subject.expiry_date.to_s).to eq(motoring_disqualification_end_date.to_s) }
          end
        end

        context 'without a motoring endorsement' do
          it { expect(subject.expiry_date.to_s).to eq(motoring_disqualification_end_date.to_s) }
        end
      end

      context 'without a motoring_disqualification_end_date' do
        let(:motoring_disqualification_end_date) { nil }

        context 'with a motoring endorsement' do
          let(:motoring_endorsement) { GenericYesNo::YES }
          it { expect(subject.expiry_date.to_s).to eq('2021-04-30') }
        end

        context 'without a motoring endorsement' do
          it { expect(subject.expiry_date.to_s).to eq('2020-10-31') }
        end
      end
    end
  end
end
