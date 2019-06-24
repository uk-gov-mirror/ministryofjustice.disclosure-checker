require 'spec_helper'

RSpec.describe BaseForm do
  describe '#persisted?' do
    it 'always returns false' do
      expect(subject.persisted?).to eq(false)
    end
  end

  describe '#new_record?' do
    it 'always returns true' do
      expect(subject.new_record?).to eq(true)
    end
  end

  describe '#to_key' do
    it 'always returns nil' do
      expect(subject.to_key).to be_nil
    end
  end

  describe '[]' do
    let(:disclosure_check) { instance_double(DisclosureCheck) }

    before do
      subject.disclosure_check = disclosure_check
    end

    it 'read the attribute directly without using the method' do
      expect(subject).not_to receive(:disclosure_check)
      expect(subject[:disclosure_check]).to eq(disclosure_check)
    end
  end

  describe '[]=' do
    let(:disclosure_check) { instance_double(DisclosureCheck) }

    it 'assigns the attribute directly without using the method' do
      expect(subject).not_to receive(:disclosure_check=)
      subject[:disclosure_check] = disclosure_check
      expect(subject.disclosure_check).to eq(disclosure_check)
    end
  end

  describe 'delegate some frequently used methods to `disclosure_check`' do
    let(:disclosure_check) {
      instance_double(
        DisclosureCheck, conviction_type: 'conviction_type', conviction_subtype: 'conviction_subtype'
      )
    }

    before do
      allow(subject).to receive(:disclosure_check).and_return(disclosure_check)
    end

    describe '#conviction_type' do
      it 'delegates to `disclosure_checker`' do
        expect(subject.conviction_type).to eq('conviction_type')
        expect(disclosure_check).to have_received(:conviction_type)
      end
    end

    describe '#conviction_subtype' do
      it 'delegates to `disclosure_checker`' do
        expect(subject.conviction_subtype).to eq('conviction_subtype')
        expect(disclosure_check).to have_received(:conviction_subtype)
      end
    end
  end
end
