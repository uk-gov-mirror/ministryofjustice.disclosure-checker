require 'spec_helper'

RSpec.describe Steps::Conviction::RehabilitationPreventionOrderForm do
  let(:arguments) do
    {
      disclosure_check: disclosure_check,
      rehabilitation_prevention_order: rehabilitation_prevention_order
    }
  end
  let(:disclosure_check) { instance_double(DisclosureCheck, rehabilitation_prevention_order: rehabilitation_prevention_order) }
  let(:rehabilitation_prevention_order) { nil }

  subject { described_class.new(arguments) }

  describe '.choices' do
    it 'returns the relevant choices' do
      expect(described_class.choices).to eq(%w(
        attendance_centre_order
        drug_rehabilitation
        reparation_order
        sexual_harm_prevention_order
        supervision_order
        youth_rehabilitation_order
      ))
    end
  end

  describe '#save' do
    it_behaves_like 'a value object form', attribute_name: :rehabilitation_prevention_order, example_value: 'drug_rehabilitation'

    context 'when form is valid' do
      let(:rehabilitation_prevention_order) { 'drug_rehabilitation' }

      it 'saves the record' do
        expect(disclosure_check).to receive(:update).with(
          rehabilitation_prevention_order: rehabilitation_prevention_order
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end
