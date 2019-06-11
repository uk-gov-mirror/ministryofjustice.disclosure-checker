RSpec.describe ConvictionResultPresenter do
  subject { described_class.new(disclosure_check) }

  let(:disclosure_check) { build(:disclosure_check, :conviction) }

  describe '#calculator_class' do
    it { expect(subject.calculator_class).to eq(ConvictionExpiryCalculator) }
  end

  describe '#to_partial_path' do
    it { expect(subject.to_partial_path).to eq('steps/check/results/conviction') }
  end

  describe '#question_attributes' do
    it { expect(subject.question_attributes).to eq([]) }
  end

  describe '#summary' do
    let(:summary) { subject.summary }

    it 'return array of objects' do
      expect(summary.size).to eq(0)
    end
  end

  describe '#expiry_date' do
    before do
      allow_any_instance_of(ConvictionExpiryCalculator).to receive(:expiry_date).and_return('foobar')
    end

    it 'delegates the method to the calculator' do
      expect(subject.expiry_date).to eq('foobar')
    end
  end
end
