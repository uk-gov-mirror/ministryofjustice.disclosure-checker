require 'rails_helper'

class TestHelper < ActionView::Base ; end

RSpec.describe CustomFormHelpers, type: :helper do
  let(:helper) { TestHelper.new }
  let(:builder) do
    GOVUKDesignSystemFormBuilder::FormBuilder.new(
      :disclosure_check,
      DisclosureCheck.new,
      helper,
      {}
    )
  end

  describe '#continue_button' do
    it 'outputs the govuk continue button' do
      expect(
        builder.continue_button
      ).to eq('<input type="submit" name="commit" value="Continue" class="govuk-button" formnovalidate="formnovalidate" data-module="govuk-button" data-prevent-double-click="true" data-disable-with="Continue" />')
    end
  end
end
