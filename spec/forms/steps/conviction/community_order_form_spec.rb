require 'spec_helper'

RSpec.describe Steps::Conviction::CommunityOrderForm do
  let(:arguments) do
    {
      disclosure_check: disclosure_check,
      community_order: community_order
    }
  end
  let(:disclosure_check) { instance_double(DisclosureCheck, community_order: community_order) }
  let(:community_order) { nil }

  subject { described_class.new(arguments) }

  describe '.choices' do
    it 'returns the relevant choices' do
      expect(described_class.choices).to eq(%w(
        alcohol_abstinence
        alcohol_treatment
        behavioural_change_programme
        curfew
        drug_rehabilitation
        exclusion_requirement
        foreign_travel_prohibition
        mental_health_treatment
        prohibition
        referral_order
        rehabilitation_activity_requirement
        residence_requirement
        unpaid_work
      ))
    end
  end

  describe '#save' do
    it_behaves_like 'a value object form', attribute_name: :community_order, example_value: 'alcohol_abstinence'

    context 'when form is valid' do
      let(:community_order) { 'alcohol_abstinence' }

      it 'saves the record' do
        expect(disclosure_check).to receive(:update).with(
          community_order: 'alcohol_abstinence'
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end

