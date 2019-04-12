require 'spec_helper'

RSpec.describe Steps::Conviction::MilitaryForm do
  let(:arguments) do
    {
      disclosure_check: disclosure_check,
      military: military
    }
  end
  let(:disclosure_check) { instance_double(DisclosureCheck, military: military) }
  let(:military) { nil }

  subject { described_class.new(arguments) }

  describe '.choices' do
    it 'returns the relevant choices' do
      expect(described_class.choices).to eq(%w(
        military_disposal
        removal_from_hms
        service_detention
      ))
    end
  end

  describe '#save' do
    it_behaves_like 'a value object form', attribute_name: :military, example_value: 'service_detention'

    context 'when form is valid' do
      let(:military) { 'service_detention' }

      it 'saves the record' do
        expect(disclosure_check).to receive(:update).with(
          military: military
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end
