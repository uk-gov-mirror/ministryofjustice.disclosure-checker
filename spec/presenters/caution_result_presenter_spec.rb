RSpec.describe CautionResultPresenter do
  subject { described_class.new(disclosure_check) }

  let(:disclosure_check) { build(:disclosure_check) }

  describe '#calculator_class' do
    it { expect(subject.calculator_class).to eq(CautionExpiryCalculator) }
  end

  describe '#to_partial_path' do
    it { expect(subject.to_partial_path).to eq('steps/check/results/caution') }
  end

  describe '#question_attributes' do
    it { expect(subject.question_attributes).to eq( [:kind, :is_date_known, :known_date, :under_age, :caution_type]) }
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
    before do
      allow_any_instance_of(CautionExpiryCalculator).to receive(:expiry_date).and_return('foobar')
    end

    it 'delegates the method to the calculator' do
      expect(subject.expiry_date).to eq('foobar')
    end
  end
end
