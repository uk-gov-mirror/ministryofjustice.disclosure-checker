require 'spec_helper'

RSpec.describe Steps::Caution::ConditionalEndDateForm do
  it_behaves_like 'a date question form', attribute_name: :conditional_end_date, allow_future: true do
    before do
      allow(subject).to receive(:after_caution_date?).and_return(true)
    end

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

  context '#after_caution_date? validation' do
    let(:disclosure_check) { instance_double(DisclosureCheck, known_date: known_date) }
    let(:known_date) { Date.today }
    let(:conditional_end_date) { nil }
    let(:arguments) {
      {
        disclosure_check: disclosure_check,
        conditional_end_date: conditional_end_date
      }
    }

    subject { described_class.new(arguments) }

    context 'when conditional end date is before caution date' do
      let(:conditional_end_date) { Date.yesterday }

      it 'returns false' do
        expect(subject.save).to be(false)
      end

      it 'has a validation error on the field' do
        expect(subject).to_not be_valid
        expect(subject.errors.added?(:conditional_end_date, :after_caution_date)).to eq(true)
      end
    end

    context 'when conditional end date is after caution date' do
      let(:conditional_end_date) { Date.tomorrow }
      let(:known_date) { 3.months.ago.to_date }

      it 'has no validation errors on the field' do
        expect(subject).to be_valid
        expect(subject.errors.added?(:conditional_end_date, :after_caution_date)).to eq(false)
      end
    end
  end
end
