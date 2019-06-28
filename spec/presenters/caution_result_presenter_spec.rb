RSpec.describe CautionResultPresenter do
  subject { described_class.new(disclosure_check) }

  let(:disclosure_check) { build(:disclosure_check) }

  describe '#to_partial_path' do
    it { expect(subject.to_partial_path).to eq('results/caution') }
  end

  describe '#question_attributes' do
    it { expect(subject.question_attributes).to eq( [:kind, :known_date, :under_age, :caution_type]) }
  end

  # TODO: this needs more tests
  describe '#summary' do
    let(:summary) { subject.summary }

    it 'return array of objects' do
      expect(summary.size).to eq(4)

      expect(summary[0].question).to eql(:kind)
      expect(summary[0].answer).to eql('caution')
    end
  end

  describe '#expiry_date' do
    before do
      allow_any_instance_of(CautionCheckResult).to receive(:expiry_date).and_return('foobar')
    end

    it 'delegates the method to the calculator' do
      expect(subject.expiry_date).to eq('foobar')
    end
  end
end
