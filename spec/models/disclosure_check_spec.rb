require 'rails_helper'

RSpec.describe DisclosureCheck, type: :model do
  describe 'caution?' do
    subject { disclosure_check.caution? }

    context 'kind set to caution ' do
      let(:disclosure_check) { build(:disclosure_check) }
      it 'return true when kind is set to caution' do
        expect(subject).to eq true
      end
    end

    context 'kind set to conviction' do
      let(:disclosure_check) { build(:disclosure_check, :conviction) }
      it 'return false when kind is set to conviction' do
        expect(subject).to eq false
      end
    end
  end
end
