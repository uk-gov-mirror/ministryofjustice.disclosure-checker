require 'spec_helper'

RSpec.describe BaseForm do
  describe '#persisted?' do
    it 'always returns false' do
      expect(subject.persisted?).to eq(false)
    end
  end

  describe '#new_record?' do
    it 'always returns true' do
      expect(subject.new_record?).to eq(true)
    end
  end

  describe '#to_key' do
    it 'always returns nil' do
      expect(subject.to_key).to be_nil
    end
  end

  describe '[]' do
    let(:disclosure_check) { instance_double(DisclosureCheck) }

    before do
      subject.disclosure_check = disclosure_check
    end

    it 'read the attribute directly without using the method' do
      expect(subject).not_to receive(:disclosure_check)
      expect(subject[:disclosure_check]).to eq(disclosure_check)
    end
  end

  describe '[]=' do
    let(:disclosure_check) { instance_double(DisclosureCheck) }

    it 'assigns the attribute directly without using the method' do
      expect(subject).not_to receive(:disclosure_check=)
      subject[:disclosure_check] = disclosure_check
      expect(subject.disclosure_check).to eq(disclosure_check)
    end
  end

  describe 'conviction_type and conviction_subtype value objects' do
    let(:disclosure_check) {
      instance_double(
        DisclosureCheck, conviction_type: 'referral_supervision_yro', conviction_subtype: 'referral_order'
      )
    }

    before do
      allow(subject).to receive(:disclosure_check).and_return(disclosure_check)
    end

    describe '#conviction_type' do
      it 'returns the value object constant' do
        expect(subject.conviction_type).to eq(ConvictionType::REFERRAL_SUPERVISION_YRO)
      end
    end

    describe '#conviction_subtype' do
      it 'returns the value object constant' do
        expect(subject.conviction_subtype).to eq(ConvictionType::REFERRAL_ORDER)
      end
    end
  end

  describe 'APPROXIMATE_DATE_ATTRS' do
    it 'returns the expected attributes' do
      expect(described_class::APPROXIMATE_DATE_ATTRS).to eq([
        :approximate_known_date,
        :approximate_conviction_date,
        :approximate_conditional_end_date,
        :approximate_compensation_payment_date,
      ])
    end
  end

  describe '#approximate_dates?' do
    let(:disclosure_check) {
      instance_double(
        DisclosureCheck,
        approximate_conviction_date: approximate_conviction_date,
        approximate_known_date: approximate_known_date
      )
    }

    let(:approximate_conviction_date) { false }
    let(:approximate_known_date) { false }

    before do
      allow(subject).to receive(:disclosure_check).and_return(disclosure_check)
    end

    context 'there is at least one approximate date' do
      let(:approximate_known_date) { true }
      it { expect(subject.approximate_dates?).to eq(true) }
    end

    context 'there are no approximate dates' do
      it { expect(subject.approximate_dates?).to eq(false) }
    end

    context 'there are nil values' do
      let(:approximate_known_date) { nil }
      it { expect(subject.approximate_dates?).to eq(false) }
    end
  end
end
