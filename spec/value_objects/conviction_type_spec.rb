require 'rails_helper'

RSpec.describe ConvictionType do
  describe 'PARENT_TYPES' do
    let(:values) { described_class::PARENT_TYPES.map(&:to_s) }

    it 'returns top level conviction' do
      expect(values).to eq(%w(
        community_order
        custodial_sentence
        discharge
        financial
        hospital_order
        military
        motoring
        rehab_prev_order
      ))
    end
  end

  describe 'Conviction subtypes' do
    let(:values) { described_class.new(conviction_type).children.map(&:to_s) }

    context 'Community order' do
      let(:conviction_type) { :community_order }

      it 'returns subtypes of this conviction type' do
        expect(values).to eq(%w(
          alcohol_abstinence
          alcohol_treatment
          behavioural_change_prog
          curfew
          drug_rehabilitation
          exclusion_requirement
          foreign_travel_prohibition
          mental_health_treatment
          prohibition
          referral_order
          rehab_activity_requirement
          residence_requirement
          unpaid_work
        ))
      end
    end

    context 'Custodial sentence' do
      let(:conviction_type) { :custodial_sentence }

      it 'returns subtypes of this conviction type' do
        expect(values).to eq(%w(
          detention_training_order
          prison_sentence
          suspended_prison_sentence
        ))
      end
    end

    context 'Discharge' do
      let(:conviction_type) { :discharge }

      it 'returns subtypes of this conviction type' do
        expect(values).to eq(%w(
          absolute_discharge
          bind_over
          conditional_discharge
        ))
      end
    end

    context 'Financial penalty' do
      let(:conviction_type) { :financial }

      it 'returns subtypes of this conviction type' do
        expect(values).to eq(%w(
          penalty_fine
          compensation_to_a_victim
        ))
      end
    end

    context 'Motoring endorsement' do
      let(:conviction_type) { :motoring }

      it 'returns subtypes of this conviction type' do
        expect(values).to eq(%w(
          disqualification
          endorsement
          penalty_points
        ))
      end
    end
  end
end
