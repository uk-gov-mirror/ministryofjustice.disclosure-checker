require 'spec_helper'

RSpec.describe Steps::Conviction::DischargeForm do
  let(:arguments) do
    {
      disclosure_check: disclosure_check,
      discharge: discharge
    }
  end
  let(:disclosure_check) { instance_double(DisclosureCheck, discharge: discharge) }
  let(:community_order) { nil }

  subject { described_class.new(arguments) }

  describe '.choices' do
    it 'returns the relevant choices' do
      expect(described_class.choices).to eq(%w(
        absolute_discharge
        bind_over
        conditional_discharge_order
      ))
    end
  end

  describe '#save' do
    it_behaves_like 'a value object form', attribute_name: :discharge, example_value: 'bind_over'

    context 'when form is valid' do
      let(:discharge) { 'bind_over' }

      it 'saves the record' do
        expect(disclosure_check).to receive(:update).with(
          discharge: 'bind_over'
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end
