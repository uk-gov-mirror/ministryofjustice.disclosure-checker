require 'spec_helper'

RSpec.describe Steps::Check::KindForm do
  let(:arguments) { {
    disclosure_check: disclosure_check,
    kind: kind
  } }
  let(:disclosure_check) { instance_double(DisclosureCheck, kind: kind) }
  let(:kind) { nil }

  subject { described_class.new(arguments) }

  describe '.choices' do
    it 'returns the relevant choices' do
      expect(described_class.choices).to eq(%w(
        caution
        conviction
      ))
    end
  end

  describe '#save' do
    it_behaves_like 'a value object form', attribute_name: :kind, example_value: 'caution'

    context 'when form is valid' do
      let(:kind) { 'caution' }

      it 'saves the record' do
        expect(disclosure_check).to receive(:update).with(
          kind: 'caution'
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end
