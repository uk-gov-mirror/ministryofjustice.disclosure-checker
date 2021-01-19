RSpec.describe SpentDatePanel do
  subject { described_class.new(spent_date: spent_date, kind: 'caution') }

  let(:spent_date) { nil }
  let(:partial_path) { 'results/shared/spent_date_panel' }

  describe '#to_partial_path' do
    it { expect(subject.to_partial_path).to eq(partial_path) }
  end

  describe '#scope' do
    context 'for a past date' do
      let(:spent_date) { Date.yesterday }
      it { expect(subject.scope).to eq([partial_path, :spent]) }
    end

    context 'for a future date' do
      let(:spent_date) { Date.tomorrow }
      it { expect(subject.scope).to eq([partial_path, :not_spent]) }
    end

    context 'when offense will never be spent' do
      let(:spent_date) { :never_spent }
      it { expect(subject.scope).to eq([partial_path, :never_spent]) }
    end
  end

  describe '#date' do
    context 'it is a date instance' do
      let(:spent_date) { Date.new(2018, 10, 31) }
      it { expect(subject.date).to eq('31 October 2018') }
    end

    context 'it is not a date instance' do
      let(:spent_date) { :never_spent }
      it { expect(subject.date).to be_nil }
    end
  end
end
