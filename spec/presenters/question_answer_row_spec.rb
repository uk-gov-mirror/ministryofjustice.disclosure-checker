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
    it { expect(subject.answer).to eq('answer') }
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
