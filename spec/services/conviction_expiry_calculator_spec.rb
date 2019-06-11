require 'rails_helper'

RSpec.describe ConvictionExpiryCalculator do
  subject { described_class.new(disclosure_check: disclosure_check) }

  context '#expiry_date' do
    let(:disclosure_check) { build(:disclosure_check, :conviction) }
    let(:expiry_date) { subject.expiry_date }

    it 'returns error' do
      expect { expiry_date }.to raise_error(NotImplementedError)
    end
  end
end
