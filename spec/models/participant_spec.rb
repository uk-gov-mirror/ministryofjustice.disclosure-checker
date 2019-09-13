require 'rails_helper'

RSpec.describe Participant, type: :model do
  describe '.valid_reference?' do
    context 'for a valid reference' do
      let(:reference) { 'test' }
      it { expect(described_class.valid_reference?(reference)).to eq(true) }
    end

    context 'for an invalid reference' do
      let(:reference) { 'foobar' }
      it { expect(described_class.valid_reference?(reference)).to eq(false) }
    end

    context 'for a blank reference' do
      let(:reference) { '' }
      it { expect(described_class.valid_reference?(reference)).to eq(false) }
    end
  end
end
