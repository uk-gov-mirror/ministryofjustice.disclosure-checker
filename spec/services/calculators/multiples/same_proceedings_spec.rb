require 'rails_helper'

RSpec.describe Calculators::Multiples::SameProceedings do
  subject { described_class.new(check_group) }

  let(:check_group) { instance_double(CheckGroup, disclosure_checks: [disclosure_check1, disclosure_check2, disclosure_check3]) }

  let(:disclosure_check1) { instance_double(DisclosureCheck, kind: 'conviction', known_date: known_date1, relevant_order?: false) }
  let(:disclosure_check2) { instance_double(DisclosureCheck, kind: 'conviction', known_date: known_date2, relevant_order?: false) }
  let(:disclosure_check3) { instance_double(DisclosureCheck, kind: 'conviction', known_date: known_date3, relevant_order?: false) }

  let(:check_result1) { instance_double(CheckResult, expiry_date: Date.new(2015, 10, 31)) }
  let(:check_result2) { instance_double(CheckResult, expiry_date: Date.new(2018, 10, 31)) }
  let(:check_result3) { instance_double(CheckResult, expiry_date: Date.new(2016, 10, 31)) }

  let(:check_never_spent) { instance_double(CheckResult, expiry_date: ResultsVariant::NEVER_SPENT) }
  let(:check_indefinite) { instance_double(CheckResult, expiry_date: ResultsVariant::INDEFINITE) }

  let(:known_date1) { Date.new(2018, 1, 1) }
  let(:known_date2) { Date.new(2015, 1, 1) }
  let(:known_date3) { Date.new(2016, 1, 1) }

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

  context '#start_date' do
    it 'returns the earliest known date from all the dates' do
      expect(subject.start_date).to eq(known_date2)
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
  end
end
