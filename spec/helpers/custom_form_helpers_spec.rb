require 'rails_helper'

class TestHelper < ActionView::Base
end

# The module `CustomFormHelpers` gets mixed in and extends the helpers already
# provided by `GovukElementsFormBuilder`. Refer to: `config/initializers/form_builder.rb`
#
RSpec.describe GovukElementsFormBuilder::FormBuilder do
  let(:helper) { TestHelper.new }

  describe '#continue_button' do
    let(:builder) { described_class.new :whatever, Object.new, helper, {} }
    let(:html_output) { builder.continue_button }

    it 'outputs the continue button' do
      expect(
        html_output
      ).to eq('<div class="form-submit"><input type="submit" name="commit" value="Continue" class="button" data-disable-with="Continue" /></div>')
    end
  end
end
