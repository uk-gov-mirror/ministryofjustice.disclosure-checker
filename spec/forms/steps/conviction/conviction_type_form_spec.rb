require 'spec_helper'

RSpec.describe Steps::Conviction::ConvictionTypeForm do
  let(:arguments) do
    {
      disclosure_check: disclosure_check,
      conviction_type: conviction_type
    }
  end

  let(:disclosure_check) { instance_double(DisclosureCheck, conviction_type: nil) }
  let(:conviction_type) { nil }

  subject { described_class.new(arguments) }

  describe '.choices' do
    it 'returns the relevant choices' do
      expect(described_class.choices).to eq(%w(
        armed_forces
        community_order
        custodial_sentence
        discharge
        financial
        hospital_guard_order
      ))
    end
  end

  describe '#save' do
    it_behaves_like 'a value object form', attribute_name: :conviction_type, example_value: 'discharge'

    context 'when form is valid' do
      let(:conviction_type) { 'discharge' }

      it 'saves the record' do
        expect(disclosure_check).to receive(:update).with(
          conviction_type: 'discharge',
          # Dependent attributes to be reset
          conviction_subtype: nil
        ).and_return(true)

        expect(subject.save).to be(true)
      end

      context 'when conviction_type is already the same on the model' do
        let(:disclosure_check) { instance_double(DisclosureCheck, conviction_type: conviction_type) }
        let(:conviction_type)  { 'community_order' }

        it 'does not save the record but returns true' do
          expect(disclosure_check).to_not receive(:update)
          expect(subject.save).to be(true)
        end
      end
    end
  end
end
