require 'rails_helper'

RSpec.describe Calculators::Multiples::SeparateProceedings do
  subject { described_class.new(check_group) }

  let(:check_group) { instance_double(CheckGroup, disclosure_checks: [disclosure_check]) }
  let(:disclosure_check) { instance_double(DisclosureCheck, kind: kind, conviction_date: conviction_date, relevant_order?: false) }

  let(:check_result) { instance_double(CheckResult, expiry_date: expiry_date) }
  let(:conviction_date) { Date.new(2015, 12, 25) }
  let(:expiry_date) { Date.new(2018, 10, 31) }
  let(:kind) { nil }

  describe '#kind' do
    context 'for a caution' do
      let(:kind) { 'caution' }
      it { expect(subject.kind).to eq(CheckKind::CAUTION) }
    end

    context 'for a conviction' do
      let(:kind) { 'conviction' }
      it { expect(subject.kind).to eq(CheckKind::CONVICTION) }
    end
  end

  describe '#conviction?' do
    context 'for a caution' do
      let(:kind) { 'caution' }
      it { expect(subject.conviction?).to eq(false) }
    end

    context 'for a conviction' do
      let(:kind) { 'conviction' }
      it { expect(subject.conviction?).to eq(true) }
    end
  end

  context '#conviction_date' do
    it 'returns the date of the conviction' do
      expect(subject.conviction_date).to eq(conviction_date)
    end
  end

  context '#spent_date' do
    before do
      allow(CheckResult).to receive(:new).with(
        disclosure_check: disclosure_check
      ).and_return(check_result)
    end

    it 'calculates and returns the spent date of the caution or conviction' do
      expect(subject.spent_date).to eq(expiry_date)
    end
  end

  describe '#spent_date_without_relevant_orders' do
    let(:conviction_subtype) { ConvictionType::ADULT_ABSOLUTE_DISCHARGE }

    let(:disclosure_check) do
      instance_double(
        DisclosureCheck,
        kind: CheckKind::CONVICTION.to_s,
        known_date: conviction_date,
        conviction_date: conviction_date,
        relevant_order?: conviction_subtype.relevant_order?,
        conviction_subtype: conviction_subtype.value,
        conviction_type: conviction_subtype.parent.value
      )
    end

    context 'when a disclosure_check is not a relevant order' do
      it 'returns the expiry date' do
        expect(subject.spent_date_without_relevant_orders).to eq(Date.new(2015, 12, 25))
      end
    end

    context 'when there is one relevant order' do
      let(:conviction_subtype) { ConvictionType::ADULT_CONDITIONAL_DISCHARGE }

      it 'returns nil' do
        expect(subject.spent_date_without_relevant_orders).to be_nil
      end
    end
  end
end
