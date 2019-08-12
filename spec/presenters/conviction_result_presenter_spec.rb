RSpec.describe ConvictionResultPresenter do
  subject { described_class.new(disclosure_check) }

  let(:disclosure_check) { build(:disclosure_check, :dto_conviction) }

  describe '#to_partial_path' do
    it { expect(subject.to_partial_path).to eq('results/conviction') }
  end

  describe '#check_kind' do
    it { expect(subject.check_kind).to eq('conviction') }
  end

  describe '#custodial_sentence?' do
    let(:disclosure_check) { instance_double(DisclosureCheck, conviction_type: conviction_type) }

    context 'for a youth `CUSTODIAL_SENTENCE` conviction type' do
      let(:conviction_type) { ConvictionType::CUSTODIAL_SENTENCE.to_s }
      it { expect(subject.custodial_sentence?).to eq(true) }
    end

    context 'for an adult `ADULT_CUSTODIAL_SENTENCE` conviction type' do
      let(:conviction_type) { ConvictionType::ADULT_CUSTODIAL_SENTENCE.to_s }
      it { expect(subject.custodial_sentence?).to eq(true) }
    end

    context 'for a `DISCHARGE` conviction type' do
      let(:conviction_type) { ConvictionType::DISCHARGE.to_s }
      it { expect(subject.custodial_sentence?).to eq(false) }
    end
  end

  describe '#summary' do
    let(:summary) { subject.summary }

    it 'returns the correct question-answer pairs' do
      expect(summary.size).to eq(6)

      expect(summary[0].question).to eql(:kind)
      expect(summary[0].answer).to eql('conviction')

      expect(summary[1].question).to eql(:conviction_type)
      expect(summary[1].answer).to eql('custodial_sentence')

      expect(summary[2].question).to eql(:conviction_subtype)
      expect(summary[2].answer).to eql('detention_training_order')

      expect(summary[3].question).to eql(:under_age)
      expect(summary[3].answer).to eql('yes')

      expect(summary[4].question).to eql(:known_date)
      expect(summary[4].answer).to eq('31 October 2018')

      expect(summary[5].question).to eql(:conviction_length)
      expect(summary[5].answer).to eq('9 weeks')
    end

    context 'when no length given' do
      let(:disclosure_check) {
        build(:disclosure_check, :dto_conviction, conviction_length_type: ConvictionLengthType::NO_LENGTH)
      }

      it 'returns the correct question-answer pairs' do
        expect(summary.size).to eq(6)

        expect(summary[5].question).to eql(:conviction_length)
        expect(summary[5].answer).to eq('No length was given')
      end
    end

    context 'pay a victim compensation' do
      let(:disclosure_check) { build(:disclosure_check, :compensation) }

      it 'returns the correct question-answer pairs' do
        expect(summary.size).to eq(6)

        expect(summary[0].question).to eql(:kind)
        expect(summary[0].answer).to eql('conviction')

        expect(summary[1].question).to eql(:conviction_type)
        expect(summary[1].answer).to eql('financial')

        expect(summary[2].question).to eql(:conviction_subtype)
        expect(summary[2].answer).to eql('compensation_to_a_victim')

        expect(summary[3].question).to eql(:under_age)
        expect(summary[3].answer).to eql('yes')

        expect(summary[4].question).to eql(:known_date)
        expect(summary[4].answer).to eq('31 October 2018')

        expect(summary[5].question).to eql(:compensation_payment_date)
        expect(summary[5].answer).to eq('31 October 2019')
      end
    end
  end

  describe '#expiry_date' do
    before do
      allow_any_instance_of(ConvictionCheckResult).to receive(:expiry_date).and_return('foobar')
    end

    it 'delegates the method to the calculator' do
      expect(subject.expiry_date).to eq('foobar')
    end
  end
end
