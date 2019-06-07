require 'rails_helper'

class TestHelper < ActionView::Base
end

RSpec.describe GovukComponents::FormBuilder do
  let(:helper) { TestHelper.new }

  def strip_text(text)
    text = text.strip.split("\n").map(&:strip)
    text.delete_if { |line| line == '' }
    text.join
  end

  describe '#continue_button' do
    let(:builder) { described_class.new :whatever, Object.new, helper, {} }
    let(:html_output) { builder.continue_button }

    it 'outputs the continue button' do
      expect(
        html_output
      ).to eq('<input type="submit" name="commit" value="Continue" class="govuk-button" data-disable-with="Continue" />')
    end
  end

  # Note: This is just a very broad and `happy path` test.
  # It is also coupled to current i18n so, if the strings change,
  # then the HTML fixture will need to also be updated.
  #
  describe '#radio_button_fieldset' do
    let(:disclosure_check) { DisclosureCheck.new }
    let(:form) { 'steps_check_kind_form' }
    let(:builder) { described_class.new form.to_sym, disclosure_check, helper, {} }
    let(:legend_options) { { page_heading: true} }
    let(:radio_hint) { nil }
    let(:choices) { CheckKind.string_values }
    let(:options) do
      {
        choices: choices,
        legend_options: legend_options,
        radio_hint: radio_hint
      }
    end
    let(:attribute) { 'kind' }
    let(:html_output) do
      builder.radio_button_fieldset attribute.to_sym, options
    end

    context 'no errors' do
      let(:html_fixture) { file_fixture('radio_button_fieldset.html').read }

      it 'outputs the expected markup' do
        expect(
          strip_text(html_output)
        ).to eq(
          strip_text(html_fixture)
        )
      end

      it 'does not contains radio label' do
        expect(
          strip_text(html_output)
        ).not_to match(/govuk-hint govuk-radios__hint/)
      end
    end

    context 'radio with hints' do
      let(:attribute) { 'under_age' }
      let(:form) { 'my_form' }
      let(:radio_hint) { true }
      let(:choices) { [:yes, :no] }

      it 'contains radio label' do
        expect(
          strip_text(html_output)
        ).to match(/<span class="govuk-hint govuk-radios__hint" id="my_form_under_age_yes_hint">/)

        expect(
          strip_text(html_output)
        ).to match(/<span class="govuk-hint govuk-radios__hint" id="my_form_under_age_no_hint">/)
      end
    end

    context 'page_heading with a virtual attribute' do
      let(:legend_options) { { virtual_attribute: 'example_attribute' } }

      it 'outputs the expected markup' do
        expect(
          strip_text(html_output)
        ).to match(/<h1 class="govuk-fieldset__heading">Example attribute<\/h1>/)
      end
    end

    context 'page_heading set to false' do
      let(:legend_options) { { page_heading: false } }

      let(:html_fixture) { file_fixture('radio_button_fieldset_legend_options.html').read }

      it 'outputs the expected markup' do
        expect(
          strip_text(html_output)
        ).to eq(
          strip_text(html_fixture)
        )
      end
    end

    context 'with errors' do
      let(:html_fixture) { file_fixture('radio_button_fieldset_error.html').read }

      before do
        disclosure_check.errors.add(:kind, :inclusion)
      end

      it 'outputs the expected markup' do
        expect(
          strip_text(html_output)
        ).to eq(
          strip_text(html_fixture)
        )
      end
    end
  end
end
