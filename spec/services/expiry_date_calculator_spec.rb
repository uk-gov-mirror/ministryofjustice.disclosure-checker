require 'rails_helper'

RSpec.describe ExpiryDateCalculator do
  subject { described_class.new(disclosure_check: disclosure_check).expiry_date }

  context 'caution' do
    context 'End date is date of caution' do
      let(:disclosure_check) { build(:disclosure_check) }
      it 'returns caution_date' do
        expect(subject).to eq(disclosure_check.caution_date)
      end
    end

    context 'Caution with conditional ' do
      let(:disclosure_check) { build(:disclosure_check, :conditional_caution) }
      it 'returns conditional_end_date' do
        expect(subject).to eq(disclosure_check.conditional_end_date)
      end
    end
  end

  context 'conviction' do
    let(:disclosure_check) { build(:disclosure_check, :conviction) }
    it 'returns error' do
      expect { subject }.to raise_error(NotImplementedError)
    end
  end
end
