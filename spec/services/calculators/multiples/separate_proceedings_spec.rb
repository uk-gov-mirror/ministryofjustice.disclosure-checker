require 'rails_helper'

RSpec.describe Calculators::Multiples::SeparateProceedings do
  subject { described_class.new(check_group) }

  let(:check_group) { instance_double(CheckGroup, disclosure_checks: [disclosure_check]) }
  let(:disclosure_check) { instance_double(DisclosureCheck) }

  let(:check_result) { instance_double(CheckResult, expiry_date: expiry_date) }
  let(:expiry_date) { Date.new(2018, 10, 31) }

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
end
