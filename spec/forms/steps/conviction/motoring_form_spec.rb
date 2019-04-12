require 'spec_helper'

RSpec.describe Steps::Conviction::MotoringForm do
  let(:arguments) do
    {
      disclosure_check: disclosure_check,
      motoring: motoring
    }
  end
  let(:disclosure_check) { instance_double(DisclosureCheck, motoring: motoring) }
  let(:motoring) { nil }

  subject { described_class.new(arguments) }

  describe '.choices' do
    it 'returns the relevant choices' do
      expect(described_class.choices).to eq(%w(
        disqualification
        endorsement
        penalty_points
      ))
    end
  end

  describe '#save' do
    it_behaves_like 'a value object form', attribute_name: :motoring, example_value: 'disqualification'

    context 'when form is valid' do
      let(:motoring) { 'disqualification' }

      it 'saves the record' do
        expect(disclosure_check).to receive(:update).with(
          motoring: motoring
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end
