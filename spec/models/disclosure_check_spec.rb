require 'rails_helper'

RSpec.describe DisclosureCheck, type: :model do
  subject { described_class.new(attributes) }

  let(:attributes) { {} }

  describe '#relevant_order?' do
    context 'when conviction_subtype is nil' do
      it { expect(subject.relevant_order?).to be false }
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

  describe '#drag_through?' do
    context 'when conviction_subtype is nil' do
      it { expect(subject.drag_through?).to be false }
    end

    context 'when conviction_subtype is a relevant order that does not drag_through' do
      let(:attributes) { super().merge(conviction_subtype: 'bind_over') }

      it { expect(subject.drag_through?).to be false }
    end

    context 'when conviction_subtype is a relevant order that drags through' do
      let(:attributes) { super().merge(conviction_subtype: 'restraining_order') }

      it { expect(subject.drag_through?).to be true }
    end
  end
end
