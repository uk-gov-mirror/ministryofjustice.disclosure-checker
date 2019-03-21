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
end