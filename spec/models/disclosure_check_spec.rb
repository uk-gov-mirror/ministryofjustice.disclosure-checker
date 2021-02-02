require 'rails_helper'

RSpec.describe DisclosureCheck, type: :model do
  subject { described_class.new(attributes) }

  let(:attributes) { {} }

  describe '#relevant_order?' do
    context 'when conviction_subtype is nil' do
      it { expect { subject.relevant_order? }.to raise_error(NoMethodError) }
    end

    context 'when conviction_subtype is not a relevant order' do
      let(:attributes) { super().merge(conviction_subtype: 'absolute_discharge') }

      it { expect(subject.relevant_order?).to be false }
    end

    context 'when conviction_subtype is a relevant order' do
      let(:attributes) { super().merge(conviction_subtype: 'conditional_discharge') }

      it { expect(subject.relevant_order?).to be true }
    end
  end
end
