require 'rails_helper'

RSpec.describe Calculators::Multiples::SameProceedings do
  subject { described_class.new(check_group) }

  let(:check_group) { instance_double(CheckGroup, disclosure_checks: [disclosure_check1, disclosure_check2, disclosure_check3]) }

  let(:disclosure_check1) { instance_double(DisclosureCheck) }
  let(:disclosure_check2) { instance_double(DisclosureCheck) }
  let(:disclosure_check3) { instance_double(DisclosureCheck) }

  let(:check_result1) { instance_double(CheckResult, expiry_date: Date.new(2015, 10, 31)) }
  let(:check_result2) { instance_double(CheckResult, expiry_date: Date.new(2018, 10, 31)) }
  let(:check_result3) { instance_double(CheckResult, expiry_date: Date.new(2016, 10, 31)) }

  let(:check_never_spent) { instance_double(CheckResult, expiry_date: :never_spent) }
  let(:check_no_record) { instance_double(CheckResult, expiry_date: :no_record) }

  context '#spent_date' do
    context 'when there is at least one `never_spent` date' do
      before do
        allow(CheckResult).to receive(:new).and_return(check_result1, check_result2, check_never_spent)
      end

      it 'returns `never_spent`' do
        expect(subject.spent_date).to eq(:never_spent)
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

    context 'when there is at least one `no_record` date' do
      before do
        allow(CheckResult).to receive(:new).and_return(check_result1, check_result2, check_no_record)
      end

      it 'ignores the conviction with `no_record` and picks the latest date' do
        expect(subject.spent_date).to eq(Date.new(2018, 10, 31))
      end
    end
  end
end
