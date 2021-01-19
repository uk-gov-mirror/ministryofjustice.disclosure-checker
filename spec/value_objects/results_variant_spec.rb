require 'rails_helper'

RSpec.describe ResultsVariant do
  describe '.values' do
    it 'returns all possible values' do
      expect(described_class.values.map(&:to_s)).to eq(%w(
        spent
        not_spent
        never_spent
        spent_simple
        indefinite
      ))
    end
  end
end
