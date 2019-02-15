RSpec.shared_examples 'a value object form' do |options|
  context 'when no disclosure_check is associated with the form' do
    let(:disclosure_check) { nil }
    let(options[:attribute_name]) { options[:example_value] }

    it 'raises an error' do
      expect { subject.save }.to raise_error(BaseForm::DisclosureCheckNotFound)
    end
  end

  context 'when attribute is not given' do
    let(options[:attribute_name]) { nil }

    it 'returns false' do
      expect(subject.save).to be(false)
    end

    it 'has a validation error on the field' do
      expect(subject).to_not be_valid
      expect(subject.errors[options[:attribute_name]]).to_not be_empty
    end
  end

  context 'when attribute value is not valid' do
    let(options[:attribute_name]) { 'INVALID VALUE' }

    it 'returns false' do
      expect(subject.save).to be(false)
    end

    it 'has a validation error on the field' do
      expect(subject).to_not be_valid
      expect(subject.errors[options[:attribute_name]]).to_not be_empty
    end
  end
end
