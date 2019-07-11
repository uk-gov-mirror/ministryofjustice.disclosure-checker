RSpec.describe QuestionAnswerRow do
  subject { described_class.new(question, answer, scope: 'path/to/locales') }

  let(:question) { 'question' }
  let(:answer) { 'answer' }

  describe '#to_partial_path' do
    it { expect(subject.to_partial_path).to eq('results/shared/row') }
  end

  describe '#question' do
    it { expect(subject.question).to eq('question') }
  end

  describe '#answer' do
    context 'for a date answer' do
      let(:answer) { Date.new(2018, 10, 31) }
      it { expect(subject.answer).to eq('31/10/2018') }
    end

    context 'for an answer of other type' do
      it { expect(subject.answer).to eq('answer') }
    end
  end

  describe '#show?' do
    context 'when there is an answer' do
      it { expect(subject.show?).to eq(true) }
    end

    context 'when answer is not present' do
      let(:answer) { '' }
      it { expect(subject.show?).to eq(false) }
    end
  end
end
