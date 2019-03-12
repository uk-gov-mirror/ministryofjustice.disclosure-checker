require 'rails_helper'

RSpec.describe CautionType do
  describe '.values' do
    let(:values) do
      %w(
        youth_simple_caution
        youth_conditional_caution
        simple_caution
        conditional_caution
      )
    end

    it 'returns all possible values' do
      expect(described_class.values.map(&:to_s)).to eq(values)
    end
  end

  describe '.conditional?' do
    subject { described_class.new(value).conditional? }

    context 'Caution type is conditional' do
      let(:value) { :conditional_caution }
      it 'returns true' do 
        expect(subject).to eq true
      end
    end

    context 'Caution type is simple' do
      let(:value) { :simple_caution }
      it 'returns false' do 
        expect(subject).to eq false
      end
    end
  end

  describe '.youth?' do
    subject { described_class.new(value).youth? }

    context 'Caution type is youth' do
      let(:value) { :youth_simple_caution }
      it 'returns true' do 
        expect(subject).to eq true
      end
    end

    context 'Caution type is not youth' do
      let(:value) { :simple_caution }
      it 'returns false' do 
        expect(subject).to eq false
      end
    end
  end
end
