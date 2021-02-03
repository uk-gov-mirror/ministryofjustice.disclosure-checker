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

  describe '#to_date' do
    subject { described_class.new(value) }

    context 'when the variant is `never_spent`' do
      let(:value) { 'never_spent' }

      it 'considers an infinity date' do
        expect(subject.to_date).to eq(Date::Infinity.new)
      end
    end

    context 'when the variant is `indefinite`' do
      let(:value) { 'indefinite' }

      it 'considers a very far in the future date but not infinite' do
        expect(subject.to_date).to eq(Date.new(2049, 1, 1))
      end
    end

    # This is just a smoke test, it should not fail unless this service
    # and the code has been around for maaaaany years LOL.
    context 'when current date is over the `indefinite` date' do
      let(:value) { 'indefinite' }

      it 'fails if the `indefinite` date is no longer in the future' do
        expect(subject.to_date.future?).to be(true)
      end
    end
  end
end
