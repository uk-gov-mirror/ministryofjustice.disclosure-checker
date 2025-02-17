require 'rails_helper'

RSpec.describe ConvictionDecorator do
  context 'compensation?' do
    context 'for a conviction without compensation' do
      subject { ConvictionType::HOSPITAL_ORDER }
      it { expect(subject.compensation?).to eq(false) }
    end

    context 'for a conviction with compensation' do
      subject { ConvictionType::COMPENSATION_TO_A_VICTIM }
      it { expect(subject.compensation?).to eq(true) }
    end
  end

  describe '#custodial_sentence?' do
    context 'for a youth `CUSTODIAL_SENTENCE` conviction type' do
      subject { ConvictionType::CUSTODIAL_SENTENCE }
      it { expect(subject.custodial_sentence?).to eq(true) }
    end

    context 'for an adult `ADULT_CUSTODIAL_SENTENCE` conviction type' do
      subject { ConvictionType::ADULT_CUSTODIAL_SENTENCE }
      it { expect(subject.custodial_sentence?).to eq(true) }
    end

    context 'for a `DISCHARGE` conviction type' do
      subject { ConvictionType::DISCHARGE }
      it { expect(subject.custodial_sentence?).to eq(false) }
    end
  end

  describe '#motoring?' do
    context 'for an adult `ADULT_CUSTODIAL_SENTENCE` conviction type' do
      subject { ConvictionType::ADULT_CUSTODIAL_SENTENCE }
      it { expect(subject.motoring?).to eq(false) }
    end

    context 'for a youth `ConvictionType::YOUTH_MOTORING` conviction type' do
      subject { ConvictionType::YOUTH_MOTORING }
      it { expect(subject.motoring?).to eq(true) }
    end

    context 'for an adult `ConvictionType::ADULT_MOTORING` conviction type' do
      subject { ConvictionType::ADULT_MOTORING }
      it { expect(subject.motoring?).to eq(true) }
    end
  end

  describe '#motoring_penalty_notice?' do
    context 'for an adult `ADULT_PENALTY_NOTICE` conviction type' do
      subject { ConvictionType::ADULT_PENALTY_NOTICE }
      it { expect(subject.motoring_penalty_notice?).to eq(true) }
    end

    context 'for a youth `YOUTH_PENALTY_NOTICE` conviction type' do
      subject { ConvictionType::YOUTH_PENALTY_NOTICE }
      it { expect(subject.motoring_penalty_notice?).to eq(true) }
    end
  end

  describe '#bailable_offense?' do
    context 'for a youth `DETENTION` conviction type' do
      subject { ConvictionType::DETENTION }
      it { expect(subject.bailable_offense?).to eq(true) }
    end

    context 'for a youth `DETENTION_TRAINING_ORDER` conviction type' do
      subject { ConvictionType::DETENTION_TRAINING_ORDER }
      it { expect(subject.bailable_offense?).to eq(true) }
    end

    context 'for a youth `HOSPITAL_ORDER` conviction type' do
      subject { ConvictionType::HOSPITAL_ORDER }
      it { expect(subject.bailable_offense?).to eq(false) }
    end

    context 'for an `ADULT_PRISON_SENTENCE` conviction type' do
      subject { ConvictionType::ADULT_PRISON_SENTENCE }
      it { expect(subject.bailable_offense?).to eq(true) }
    end

    context 'for an `ADULT_SUSPENDED_PRISON_SENTENCE` conviction type' do
      subject { ConvictionType::ADULT_SUSPENDED_PRISON_SENTENCE }
      it { expect(subject.bailable_offense?).to eq(true) }
    end

    context 'for an `ADULT_HOSPITAL_ORDER` conviction type' do
      subject { ConvictionType::ADULT_HOSPITAL_ORDER }
      it { expect(subject.bailable_offense?).to eq(false) }
    end
  end
end
