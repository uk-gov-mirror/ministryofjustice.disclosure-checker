require 'rails_helper'

RSpec.describe Calculators::MotoringCalculator do
  subject { described_class.new(disclosure_check) }

  let(:disclosure_check) { build(:disclosure_check, motoring_endorsement: motoring_endorsement) }

  describe '#motoring_endorsement?' do
    context 'when no motoring endorsement' do
      let(:motoring_endorsement) { GenericYesNo::NO }

      it { expect(subject.motoring_endorsement?).to be false }
    end

    context 'when motoring endorsement' do
      let(:motoring_endorsement) { GenericYesNo::YES }

      it { expect(subject.motoring_endorsement?).to be true }
    end
  end
end
