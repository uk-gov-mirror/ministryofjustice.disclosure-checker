require 'spec_helper'

RSpec.describe Steps::Conviction::FinancialForm do
  let(:arguments) do
    {
      disclosure_check: disclosure_check,
      financial: financial
    }
  end
  let(:disclosure_check) { instance_double(DisclosureCheck, financial: financial) }
  let(:financial) { nil }

  subject { described_class.new(arguments) }

  describe '.choices' do
    it 'returns the relevant choices' do
      expect(described_class.choices).to eq(%w(
        fine
        compensation_to_a_victim
      ))
    end
  end

  describe '#save' do
    it_behaves_like 'a value object form', attribute_name: :financial, example_value: 'fine'

    context 'when form is valid' do
      let(:financial) { 'fine' }

      it 'saves the record' do
        expect(disclosure_check).to receive(:update).with(
          financial: financial
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end
