require 'spec_helper'

RSpec.describe Steps::Conviction::CustodialSentenceForm do
  let(:arguments) do
    {
      disclosure_check: disclosure_check,
      custodial_sentence: custodial_sentence
    }
  end
  let(:disclosure_check) { instance_double(DisclosureCheck, custodial_sentence: custodial_sentence) }
  let(:community_order) { nil }

  subject { described_class.new(arguments) }

  describe '.choices' do
    it 'returns the relevant choices' do
      expect(described_class.choices).to eq(%w(
       detention_and_training_order
       prision_sentence
       suspended_prision_sentence
      ))
    end
  end

  describe '#save' do
    it_behaves_like 'a value object form', attribute_name: :custodial_sentence, example_value: 'prision_sentence'

    context 'when form is valid' do
      let(:custodial_sentence) { 'prision_sentence' }

      it 'saves the record' do
        expect(disclosure_check).to receive(:update).with(
          custodial_sentence: 'prision_sentence'
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end

