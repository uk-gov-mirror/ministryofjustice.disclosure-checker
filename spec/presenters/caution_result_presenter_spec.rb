RSpec.describe CautionResultPresenter do
  subject { described_class.new(disclosure_check) }

  let(:disclosure_check) { build(:disclosure_check) }

  describe '#caution_questions' do
    it { expect(subject.caution_questions).to eq( [:kind, :is_date_known, :known_date, :under_age, :caution_type]) }
  end

  describe '#summary' do
    let(:summary) { subject.summary }

    it 'return array of objects' do
      expect(summary.size).to eq(5)

      expect(summary[0].question).to eql(:kind)
      expect(summary[0].value).to eql(disclosure_check.kind)
    end
  end

  describe '#expiry_date' do
    let(:expiry_date) { subject.expiry_date }
    context 'know caution date' do
      it 'return formatted expiry_date' do
        expect(expiry_date).to eql(disclosure_check.known_date )
      end
    end

    context 'unknow caution date' do
      let(:disclosure_check) { build(:disclosure_check, known_date: nil) }
      it 'return a string' do
        expect(expiry_date).to eql(I18n.t('caution_result'))
      end
    end
  end
end
