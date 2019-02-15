require 'spec_helper'

RSpec.describe Steps::<%= task_name.camelize %>::<%= step_name.camelize %>Form do
  let(:arguments) { {
    disclosure_check: disclosure_check,
    <%= step_name.underscore %>: <%= step_name.underscore %>
  } }
  let(:disclosure_check) { instance_double(DisclosureCheck) }
  let(:<%= step_name.underscore %>) { 3.months.ago.to_date } # Change accordingly!

  subject { described_class.new(arguments) }

  describe '#save' do
    it { should validate_presence_of(:<%= step_name.underscore %>) }

    context 'when no disclosure_check is associated with the form' do
      let(:disclosure_check) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::DisclosureCheckNotFound)
      end
    end

    context 'date validation' do
      context 'when date is not given' do
        let(:<%= step_name.underscore %>) { nil }

        it 'returns false' do
          expect(subject.save).to be(false)
        end

        it 'has a validation error on the field' do
          expect(subject).to_not be_valid
          expect(subject.errors.added?(:<%= step_name.underscore %>, :blank)).to eq(true)
        end
      end

      xcontext 'when date is invalid' do
        # Implement as needed
      end

      xcontext 'when date is in the future' do
        # Implement as needed
      end
    end

    context 'when form is valid' do
      it 'saves the record' do
        expect(disclosure_check).to receive(:update).with(
          <%= step_name.underscore %>: 3.months.ago.to_date
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end
