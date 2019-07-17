RSpec.describe CautionResultPresenter do
  subject { described_class.new(disclosure_check) }

  let(:disclosure_check) { build(:disclosure_check) }

  describe '#to_partial_path' do
    it { expect(subject.to_partial_path).to eq('results/caution') }
  end

  describe '#summary' do
    let(:summary) { subject.summary }

    context 'for a youth caution' do
      it 'returns the correct question-answer pairs' do
        expect(summary.size).to eq(4)

        expect(summary[0].question).to eql(:kind)
        expect(summary[0].answer).to eql('caution')

        expect(summary[1].question).to eql(:caution_type)
        expect(summary[1].answer).to eql('youth_simple_caution')

        expect(summary[2].question).to eql(:under_age)
        expect(summary[2].answer).to eql('yes')

        expect(summary[3].question).to eql(:known_date)
        expect(summary[3].answer).to eq('31 October 2018')
      end
    end

    context 'for a youth conditional caution' do
      let(:disclosure_check) { build(:disclosure_check, :youth_conditional_caution) }

      it 'returns the correct question-answer pairs' do
        expect(summary.size).to eq(5)

        expect(summary[0].question).to eql(:kind)
        expect(summary[0].answer).to eql('caution')

        expect(summary[1].question).to eql(:caution_type)
        expect(summary[1].answer).to eql('youth_conditional_caution')

        expect(summary[2].question).to eql(:under_age)
        expect(summary[2].answer).to eql('yes')

        expect(summary[3].question).to eql(:known_date)
        expect(summary[3].answer).to eq('31 October 2018')

        expect(summary[4].question).to eql(:conditional_end_date)
        expect(summary[4].answer).to eq('25 December 2018')
      end
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
