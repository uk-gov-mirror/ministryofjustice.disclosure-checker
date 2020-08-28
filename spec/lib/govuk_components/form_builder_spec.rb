require 'rails_helper'

class TestHelper < ActionView::Base
  def allow_to_cancel_check?; end

  def steps_check_check_your_answers_path
    '/steps/check/answers'
  end
end

RSpec.describe GovukComponents::FormBuilder do
  let(:disclosure_check) { DisclosureCheck.new }
  let(:helper) { TestHelper.new }

  def strip_text(text)
    text = text.strip.split("\n").map(&:strip)
    text.delete_if { |line| line == '' }
    text.join
  end

  describe '#continue_button' do
    let(:builder) { described_class.new :whatever, Object.new, helper, {} }
    let(:html_output) { builder.continue_button }

    before do
      allow(helper).to receive(:allow_to_cancel_check?).and_return(allow_to_cancel_check)
    end

    context 'it is not possible to cancel the current check' do
      let(:allow_to_cancel_check) { false }

      it 'outputs the continue button' do
        expect(
          html_output
        ).to eq('<button type="submit" class="govuk-button" data-module="govuk-button" data-prevent-double-click="true">Continue</button>')
      end
    end

    context 'it is possible to cancel the current check' do
      let(:allow_to_cancel_check) { true }

      it 'outputs the continue button' do
        expect(
          html_output
        ).to eq(
          '<button type="submit" class="govuk-button" data-module="govuk-button" data-prevent-double-click="true">Continue</button>' + \
          '<p class="govuk-body"><a href="/steps/check/answers" class="govuk-link govuk-link--no-visited-state ga-pageLink" data-ga-category="steps" data-ga-label="cancel check">Go back to check your answers</a></p>'
        )
      end
    end
  end

  # Note: This is just a very broad and `happy path` test.
  # It is also coupled to current i18n so, if the strings change,
  # then the HTML fixture will need to also be updated.
  #
  describe '#text_field' do
    let(:builder) { described_class.new form.to_sym, disclosure_check, helper, {} }

    let(:form) { 'steps_conviction_conviction_length_form' }
    let(:attribute) { :conviction_length }

    let(:options) do
      { input_options: { class: 'govuk-input--width-4' } }
    end

    let(:html_output) { builder.text_field attribute, options }

    context 'no errors' do
      let(:html_fixture) { file_fixture('text_field.html').read }

      it 'outputs the expected markup' do
        expect(
          strip_text(html_output)
        ).to eq(
          strip_text(html_fixture)
        )
      end
    end

    context 'with errors' do
      let(:html_fixture) { file_fixture('text_field_error.html').read }

      before do
        disclosure_check.errors.add(:conviction_length, :not_a_number)
      end

      it 'outputs the expected markup' do
        expect(
          strip_text(html_output)
        ).to eq(
          strip_text(html_fixture)
        )
      end
    end

    context 'page_heading set to false' do
      let(:html_fixture) { file_fixture('text_field_no_page_heading.html').read }

      let(:options) do
        { label_options: { page_heading: false } }
      end

      it 'outputs the expected markup' do
        expect(
          strip_text(html_output)
        ).to eq(
          strip_text(html_fixture)
        )
      end
    end

    context 'label with a virtual attribute' do
      let(:options) { super().merge(i18n_attribute: :months) }

      it 'outputs the expected markup' do
        expect(
          strip_text(html_output)
        ).to match(/<label class="govuk-label govuk-label--xl" for="steps_conviction_conviction_length_form_conviction_length">Number of months<\/label>/)
      end
    end
  end
end
