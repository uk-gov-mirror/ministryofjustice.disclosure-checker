require 'rails_helper'

RSpec.describe Calculators::Multiples::SameProceedings do
  subject { described_class.new(check_group) }

  let(:check_group) { instance_double(CheckGroup, disclosure_checks: [disclosure_check1, disclosure_check2, disclosure_check3]) }

  let(:disclosure_check1) { instance_double(DisclosureCheck, kind: 'conviction', conviction_date: conviction_date, relevant_order?: false) }
  let(:disclosure_check2) { instance_double(DisclosureCheck, kind: 'conviction', relevant_order?: false) }
  let(:disclosure_check3) { instance_double(DisclosureCheck, kind: 'conviction', relevant_order?: true) }

  let(:check_result1) { instance_double(CheckResult, expiry_date: Date.new(2015, 10, 31)) }
  let(:check_result2) { instance_double(CheckResult, expiry_date: Date.new(2018, 10, 31)) }
  let(:check_result3) { instance_double(CheckResult, expiry_date: Date.new(2016, 10, 31)) }

  let(:check_never_spent) { instance_double(CheckResult, expiry_date: ResultsVariant::NEVER_SPENT) }
  let(:check_indefinite) { instance_double(CheckResult, expiry_date: ResultsVariant::INDEFINITE) }

  let(:conviction_date) { Date.new(2018, 1, 1) }

  describe '#kind' do
    it 'is always conviction for same proceedings' do
      expect(subject.kind).to eq(CheckKind::CONVICTION)
    end
  end

  describe '#conviction?' do
    it 'is always true for same proceedings' do
      expect(subject.conviction?).to eq(true)
    end
  end

  context '#conviction_date' do
    it 'returns the date of the conviction (using the first sentence)' do
      expect(subject.conviction_date).to eq(conviction_date)
    end
  end

  context '#spent_date' do
    context 'when there is at least one `never_spent` date' do
      before do
        allow(CheckResult).to receive(:new).and_return(check_result1, check_result2, check_never_spent)
      end

      it 'returns `never_spent`' do
        expect(subject.spent_date).to eq(ResultsVariant::NEVER_SPENT)
      end
    end

    context 'when all individual spent dates are dates' do
      before do
        allow(CheckResult).to receive(:new).and_return(check_result1, check_result2, check_result3)
      end

      it 'picks the latest date' do
        expect(subject.spent_date).to eq(Date.new(2018, 10, 31))
      end
    end

    context 'when there is at least one `indefinite` date' do
      before do
        allow(CheckResult).to receive(:new).and_return(check_result1, check_result2, check_indefinite)
      end

      it 'returns `indefinite`' do
        expect(subject.spent_date).to eq(ResultsVariant::INDEFINITE)
      end
    end

    describe '#spent_date_without_relevant_orders' do
      let(:conviction_subtype) { ConvictionType::ADULT_ABSOLUTE_DISCHARGE }
      let(:conviction_subtype2) { ConvictionType::ADULT_CONDITIONAL_DISCHARGE }

      let(:disclosure_check1) do
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

      let(:disclosure_check2) do
        instance_double(
          DisclosureCheck,
          kind: CheckKind::CONVICTION.to_s,
          known_date: conviction_date,
          conviction_date: conviction_date,
          relevant_order?: conviction_subtype2.relevant_order?,
          conviction_subtype: conviction_subtype2.value,
          conviction_type: conviction_subtype2.parent.value
        )
      end

      context 'when there are two sentences and one is a relevant order' do
        it 'returns the expiry date of the non relevant order' do
          expect(subject.spent_date_without_relevant_orders).to eq(Date.new(2018, 1, 1))
        end
      end

      context 'when there is two sentences that are relevant orders' do
        let(:conviction_subtype) { ConvictionType::ADULT_CONDITIONAL_DISCHARGE }

        it 'returns nil' do
          expect(subject.spent_date_without_relevant_orders).to be_nil
        end
      end
    end
  end
end
