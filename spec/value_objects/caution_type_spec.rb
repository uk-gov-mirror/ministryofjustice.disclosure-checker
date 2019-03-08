require 'rails_helper'

RSpec.describe CautionType do
  describe '.values' do
    let(:values) do
      %w(
        simple_caution
        conditional_caution
        youth_simple_caution
        youth_conditional_caution
      )
    end

    it 'returns all possible values' do
      expect(described_class.values.map(&:to_s)).to eq(values)
    end
  end
end
