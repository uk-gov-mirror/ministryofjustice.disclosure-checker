require 'spec_helper'

RSpec.describe Steps::Check::CautionDateForm do
  let(:arguments) { {
    disclosure_check: disclosure_check,
    caution_date: caution_date
  } }
  let(:disclosure_check) { instance_double(DisclosureCheck) }
  let(:caution_date) { 3.months.ago.to_date } # Change accordingly!

  subject { described_class.new(arguments) }

  describe '#save' do
    it { should validate_presence_of(:caution_date) }

    context 'when no disclosure_check is associated with the form' do
      let(:disclosure_check) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::DisclosureCheckNotFound)
      end
    end

    context 'date validation' do
      context 'when date is not given' do
        let(:caution_date) { nil }

        it 'returns false' do
          expect(subject.save).to be(false)
        end

        it 'has a validation error on the field' do
          expect(subject).to_not be_valid
          expect(subject.errors.added?(:caution_date, :blank)).to eq(true)
        end
      end

      context 'when date is invalid' do
        let(:caution_date) { Date.new(18, 10, 31) } # 2-digits year (18)

        it 'returns false' do
          expect(subject.save).to be(false)
        end

        it 'has a validation error on the field' do
          expect(subject).to_not be_valid
          expect(subject.errors.added?(:caution_date, :invalid)).to eq(true)
        end
      end

      context 'when date is in the future' do
        let(:caution_date) { Date.tomorrow }

        it 'returns false' do
          expect(subject.save).to be(false)
        end

        it 'has a validation error on the field' do
          expect(subject).to_not be_valid
          expect(subject.errors.added?(:caution_date, :future)).to eq(true)
        end
      end
    end

    context 'when form is valid' do
      it 'saves the record' do
        expect(disclosure_check).to receive(:update).with(
          caution_date: 3.months.ago.to_date
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end
