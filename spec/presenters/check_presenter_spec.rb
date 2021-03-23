RSpec.describe CheckPresenter do
  let(:disclosure_check) { create(:disclosure_check, :completed) }
  let(:number) { 1 }
  let(:sentences) { 1 }
  let(:results_page) { false }

  subject { described_class.new(disclosure_check, number: number, sentences: sentences, results_page: results_page) }

  describe '#number' do
    it { expect(subject.number).to eq(1) }
  end

  describe '#show_sentence_header?' do
    it { expect(subject.show_sentence_header?).to be(false) }

    context 'when there are more than 1 sentence' do
      let(:sentences) { 2 }

      it { expect(subject.show_sentence_header?).to be(true) }
    end
  end

  describe '#to_partial_path' do
    it { expect(subject.to_partial_path).to eq('check_your_answers/shared/check_row') }

    context 'when results page' do
      let(:results_page) { true }

      it { expect(subject.to_partial_path).to eq('results/multiples/check_row') }
    end
  end

  describe '#summary' do
    let(:summary) { subject.summary }

    context 'for a single youth caution' do
      it 'returns CheckRow' do
        expect(summary).to be_an_instance_of(CheckRow)
        expect(summary.question_answers.size).to eq(3)
      end
    end
  end
end
