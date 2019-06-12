require 'rails_helper'

RSpec.describe ConvictionExpiryCalculator do
  subject { described_class.new(disclosure_check: disclosure_check) }

  context '#expiry_date' do
    let(:disclosure_check) { build(:disclosure_check, :conviction) }
    let(:expiry_date) { subject.expiry_date }

    it 'is not yet implemented' do
      expect(expiry_date).to eq('TBD')
    end
  end
end
