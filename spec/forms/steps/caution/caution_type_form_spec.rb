require 'spec_helper'

RSpec.describe Steps::Caution::CautionTypeForm do
  let(:arguments) do
    {
      disclosure_check: disclosure_check,
      caution_type: caution_type
    }
  end
  let(:disclosure_check) { instance_double(DisclosureCheck, caution_type: nil, under_age: under_age) }
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
          adult_simple_caution
          adult_conditional_caution
        ))
      end
    end
  end

  describe '#save' do
    it_behaves_like 'a value object form', attribute_name: :caution_type, example_value: 'youth_simple_caution'

    context 'when form is valid' do
      let(:caution_type) { 'youth_simple_caution' }

      it 'saves the record' do
        expect(disclosure_check).to receive(:update).with(
          caution_type: caution_type,
          # Dependent attributes to be reset
          known_date: nil,
          conditional_end_date: nil
        ).and_return(true)

        expect(subject.save).to be(true)
      end

      context 'when caution_type is already the same on the model' do
        let(:disclosure_check) {
          instance_double(DisclosureCheck, caution_type: 'youth_simple_caution', under_age: 'yes')
        }
        let(:caution_type) { 'youth_simple_caution' }

        it 'does not save the record but returns true' do
          expect(disclosure_check).to_not receive(:update)
          expect(subject.save).to be(true)
        end
      end
    end
  end
end
