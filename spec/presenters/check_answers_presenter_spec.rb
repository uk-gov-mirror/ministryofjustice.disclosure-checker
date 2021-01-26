RSpec.describe CheckAnswersPresenter do
  let!(:disclosure_check) { create(:disclosure_check, :completed) }
  let!(:disclosure_report) { disclosure_check.disclosure_report }

  subject { described_class.new(disclosure_report) }

  describe '.initialize' do
    context 'calculate the spent dates of the whole report' do
      context 'when the report is still in progress' do
        it 'does not process the offenses just yet' do
          expect(subject.calculator.results).to be_empty
        end
      end

      context 'when the report is completed' do
        before do
          allow(disclosure_report).to receive(:completed?).and_return(true)
        end

        it 'processes the offenses for later use' do
          expect(subject.calculator.results).not_to be_empty
        end
      end
    end
  end

  describe '#to_partial_path' do
    it { expect(subject.to_partial_path).to eq('check_your_answers/check') }
  end

  describe '#variant' do
    it { expect(subject.variant).to eq(:multiples) }
  end

  describe '#summary' do
    let(:summary) { subject.summary }
    let(:spent_date) { 'date' }

    before do
      allow(subject.calculator).to receive(:spent_date_for).and_return(spent_date)
    end

    it 'returns CheckGroupPresenter' do
      expect(summary.size).to eq(1)
      expect(summary[0]).to be_an_instance_of(CheckGroupPresenter)
      expect(summary[0].number).to eql(1)
      expect(summary[0].check_group).to eql(disclosure_check.check_group)
      expect(summary[0].spent_date).to eq(spent_date)
    end
  end
end
