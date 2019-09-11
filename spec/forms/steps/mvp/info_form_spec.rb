require 'spec_helper'

RSpec.describe Steps::Mvp::InfoForm do
  let(:arguments) { {
    disclosure_check: nil,
    record: record,
    opted_in: opted_in,
  } }

  let(:record) { instance_double(Participant) }
  let(:opted_in) { GenericYesNo::YES }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when form is valid' do
      it 'saves the record' do
        expect(record).to receive(:update).with(
          opted_in: opted_in,
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end
