require 'rails_helper'

RSpec.describe ConvictionCheckResult do
  subject { described_class.new(disclosure_check: disclosure_check) }

  let(:disclosure_check) { build(:disclosure_check, :conviction,
                                 conviction_subtype: 'hospital_order',
                                 known_date: Date.new(2018, 10, 31)) }

  context '#expiry_date' do
    it 'will call a calculator' do
      expect(subject).to receive(:calculator).and_call_original
      subject.expiry_date
    end

    it { expect(subject.calculator).to be_kind_of(BaseCalculator) }
  end
end
