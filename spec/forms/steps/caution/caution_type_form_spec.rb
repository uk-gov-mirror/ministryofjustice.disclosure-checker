require 'spec_helper'

RSpec.describe Steps::Caution::CautionTypeForm do
  let(:arguments) do
    {
      disclosure_check: disclosure_check,
      caution_type: caution_type
    }
  end
  let(:disclosure_check) { instance_double(DisclosureCheck, caution_type: caution_type, under_age: under_age) }
  let(:caution_type) { nil }
  let(:under_age) { 'yes' }

  subject { described_class.new(arguments) }

  describe '#choices' do
    context 'when under 18' do
      let(:under_age) { 'yes' }

      it 'shows only the relevant choices' do
        expect(subject.choices).to eq(%w(
          youth_simple_caution
          youth_conditional_caution
        ))
      end
    end

    context 'when over 18' do
      let(:under_age) { 'no' }

      it 'shows only the relevant choices' do
        expect(subject.choices).to eq(%w(
          simple_caution
          conditional_caution
        ))
      end
    end
  end

  describe '#save' do
    it_behaves_like 'a value object form', attribute_name: :caution_type, example_value: 'simple_caution'

    context 'when form is valid' do
      let(:caution_type) { 'youth_simple_caution' }

      it 'saves the record' do
        expect(disclosure_check).to receive(:update).with(
          caution_type: caution_type
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end
