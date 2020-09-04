require 'spec_helper'

RSpec.describe Steps::Conviction::KnownDateForm do
  it_behaves_like 'a date question form', attribute_name: :known_date

  describe '#i18n_attribute' do
    before do
      allow(subject).to receive(:conviction_subtype).and_return(:foobar)
    end

    it 'returns the key that will be used to translate legends and hints' do
      expect(subject.i18n_attribute).to eq(:foobar)
    end
  end
end
