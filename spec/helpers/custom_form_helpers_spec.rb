require 'rails_helper'

class TestHelper < ActionView::Base ; end

RSpec.describe CustomFormHelpers, type: :helper do
  let(:helper) { TestHelper.new }
  let(:form_object) { double('FormObject') }

  let(:builder) do
    GOVUKDesignSystemFormBuilder::FormBuilder.new(
      :disclosure_check,
      form_object,
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

  describe '#i18n_legend' do
    before do
      allow(form_object).to receive(:i18n_attribute).and_return(:foobar)
    end

    it 'seeks the expected locale key' do
      expect(I18n).to receive(:t).with(
        :foobar, scope: [:helpers, :legend, :disclosure_check], default: :default
      )

      builder.i18n_legend
    end
  end

  describe '#i18n_hint' do
    let(:found_locale) { double('locale') }

    before do
      allow(form_object).to receive(:i18n_attribute).and_return(:foobar)
    end

    it 'seeks the expected locale key' do
      expect(I18n).to receive(:t).with(
        'foobar_html', scope: [:helpers, :hint, :disclosure_check], default: :default_html
      ).and_return(found_locale)

      expect(found_locale).to receive(:html_safe)

      builder.i18n_hint
    end
  end
end