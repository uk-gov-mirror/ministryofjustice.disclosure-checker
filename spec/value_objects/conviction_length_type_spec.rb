require 'rails_helper'

RSpec.describe ConvictionLengthType do
  describe '.values' do
    it 'returns all possible values' do
      expect(described_class.values.map(&:to_s)).to eq(%w(
        weeks
        months
        years
        no_length
      ))
    end
  end
end
