require 'rails_helper'

RSpec.describe DisclosureReport, type: :model do
  subject { described_class.new(attributes) }

  let(:attributes) { {} }

  describe '.purge!' do
    let(:finder_double) { double.as_null_object }

    before do
      travel_to Time.now
    end

    it 'picks records equal to or older than the passed-in date' do
      expect(described_class).to receive(:where).with(
        'created_at <= :date', date: 28.days.ago
      ).and_return(finder_double)

      described_class.purge!(28.days.ago)
    end

    it 'calls #destroy_all on the records it finds' do
      allow(described_class).to receive(:where).and_return(finder_double)
      expect(finder_double).to receive(:destroy_all)

      described_class.purge!(28.days.ago)
    end
  end

  describe '#completed!' do
    before do
      travel_to Time.at(123)
    end

    it 'marks the application as completed' do
      expect(
        subject
      ).to receive(:update!).with(
        status: :completed, completed_at: Time.at(123)
      ).and_return(true)

      subject.completed!
    end
  end
end
