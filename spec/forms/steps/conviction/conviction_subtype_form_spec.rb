require 'spec_helper'

RSpec.describe Steps::Conviction::ConvictionSubtypeForm do
  let(:arguments) do
    {
      disclosure_check: disclosure_check,
      conviction_subtype: conviction_subtype,
    }
  end

  let(:disclosure_check) {
    instance_double(DisclosureCheck, conviction_type: conviction_type, conviction_subtype: conviction_subtype)
  }

  let(:conviction_type) { 'community_order' } # any conviction with children will do
  let(:conviction_subtype) { nil }

  subject { described_class.new(arguments) }

  # Note: no need to check for all the returned values, as we cover this extensively
  # in the value-object spec `spec/value_objects/conviction_type_spec.rb`
  describe '#choices' do
    it 'returns the relevant choices (children of the conviction type)' do
      expect(subject.choices).to include('alcohol_abstinence_treatment', 'bind_over', 'curfew')
    end
  end

  describe '#save' do
    it_behaves_like 'a value object form', attribute_name: :conviction_subtype, example_value: 'alcohol_abstinence_treatment'

    context 'when form is valid' do
      let(:conviction_subtype) { 'alcohol_abstinence_treatment' }

      it 'saves the record' do
        expect(disclosure_check).to receive(:update).with(
          conviction_subtype: conviction_subtype
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end
