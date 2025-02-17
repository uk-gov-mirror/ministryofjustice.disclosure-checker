require 'rails_helper'

RSpec.describe Calculators::Motoring::Youth::PenaltyNotice do
  subject { described_class.new(disclosure_check) }

  let(:disclosure_check) { build(:disclosure_check,
                                 under_age: under_age,
                                 known_date: known_date,
                                 motoring_endorsement: motoring_endorsement) }

  let(:under_age) { GenericYesNo::YES }
  let(:known_date) { Date.new(2020, 1, 1) }
  let(:motoring_endorsement) { GenericYesNo::NO }

  describe '#expiry_date' do
    context 'with a motoring endorsement' do
      let(:motoring_endorsement) { GenericYesNo::YES }

      it { expect(subject.expiry_date.to_s).to eq('2022-07-01') }
    end

    context 'without a motoring endorsement' do
      it { expect(subject.expiry_date).to eq(:no_record) }
    end
  end
end
