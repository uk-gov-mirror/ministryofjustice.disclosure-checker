require 'spec_helper'

RSpec.describe Steps::Conviction::KnownDateForm do
  it_behaves_like 'a date question form', attribute_name: :known_date do
    # TODO: move this context to the shared examples once all dates are migrated
    context 'casting the date from multi parameters' do
      context 'when date is valid' do
        let(:date_value) { [nil, 2008, 11, 22] }
        it { expect(subject).to be_valid }
      end

      context 'when date is not valid' do
        let(:date_value) { [nil, 18, 11, 22] } # 2-digits year (18)
        it { expect(subject).not_to be_valid }
      end

      context 'when a part is missing (nil or zero)' do
        let(:date_value) { [nil, 2008, 0, 22] }
        it { expect(subject).not_to be_valid }
      end
    end
  end

  describe '#i18n_attribute' do
    before do
      allow(subject).to receive(:conviction_subtype).and_return(:foobar)
    end

    it 'returns the key that will be used to translate legends and hints' do
      expect(subject.i18n_attribute).to eq(:foobar)
    end
  end
end
