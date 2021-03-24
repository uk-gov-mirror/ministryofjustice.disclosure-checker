require 'rails_helper'

# TestController doesn't have this method so we can't stub it nicely
class ActionView::TestCase::TestController
  def previous_step_path
    '/foo/bar'
  end
end

RSpec.describe ApplicationHelper, type: :helper do
  let(:record) { DisclosureCheck.new }

  describe '#step_form' do
    let(:expected_defaults) { {
      url: {
        controller: "application",
        action: :update
      },
      html: {
        class: 'edit_disclosure_check'
      },
      method: :put
    } }
    let(:form_block) { Proc.new {} }

    it 'acts like FormHelper#form_for with additional defaults' do
      expect(helper).to receive(:form_for).with(record, expected_defaults) do |*_args, &block|
        expect(block).to eq(form_block)
      end
      helper.step_form(record, &form_block)
    end

    it 'accepts additional options like FormHelper#form_for would' do
      expect(helper).to receive(:form_for).with(record, expected_defaults.merge(foo: 'bar'))
      helper.step_form(record, { foo: 'bar' })
    end

    it 'appends optional css classes if provided' do
      expect(helper).to receive(:form_for).with(record, expected_defaults.merge(html: {class: %w(test edit_disclosure_check)}))
      helper.step_form(record, html: {class: 'test'})
    end
  end

  describe '#step_header' do
    let(:form_object) { double('Form object') }

    it 'renders the expected content' do
      expect(helper).to receive(:render).with(partial: 'layouts/step_header', locals: {path: '/foo/bar'}).and_return('foobar')
      assign(:form_object, form_object)

      expect(helper.step_header).to eq('foobar')
    end

    context 'a specific path is provided' do
      it 'renders the back link with provided path' do
        expect(helper).to receive(:render).with(partial: 'layouts/step_header', locals: {path: '/another/step'}).and_return('foobar')
        assign(:form_object, form_object)

        expect(helper.step_header(path: '/another/step')).to eq('foobar')
      end
    end
  end

  describe '#govuk_error_summary' do
    context 'when no form object is given' do
      let(:form_object) { nil }

      it 'returns nil' do
        expect(helper.govuk_error_summary(form_object)).to be_nil
      end
    end

    context 'when a form object without errors is given' do
      let(:form_object) { BaseForm.new }

      it 'returns nil' do
        expect(helper.govuk_error_summary(form_object)).to be_nil
      end
    end

    context 'when a form object with errors is given' do
      let(:form_object) { BaseForm.new }
      let(:title) { helper.content_for(:page_title) }

      before do
        helper.title('A page')
        form_object.errors.add(:base, :blank)
      end

      it 'returns the summary' do
        expect(
          helper.govuk_error_summary(form_object)
        ).to eq(
          '<div class="govuk-error-summary" tabindex="-1" role="alert" data-module="govuk-error-summary" aria-labelledby="error-summary-title"><h2 id="error-summary-title" class="govuk-error-summary__title">There is a problem on this page</h2><div class="govuk-error-summary__body"><ul class="govuk-list govuk-error-summary__list"><li><a data-turbolinks="false" href="#base-form-base-field-error">can&#39;t be blank</a></li></ul></div></div>'
        )
      end

      it 'prepends the page title with an error hint' do
        helper.govuk_error_summary(form_object)
        expect(title).to start_with('Error: A page')
      end
    end
  end

  describe 'capture missing translations' do
    before do
      ActionView::Base.raise_on_missing_translations = false
    end

    it 'should not raise an exception, and capture in Sentry the missing translation' do
      expect(Raven).to receive(:capture_exception).with(an_instance_of(I18n::MissingTranslationData))
      expect(Raven).to receive(:extra_context).with(
        {
          locale: :en,
          scope: nil,
          key: 'a_missing_key_here'
        }
      )
      helper.translate('a_missing_key_here')
    end
  end

  describe '#title' do
    let(:title) { helper.content_for(:page_title) }

    before do
      helper.title(value)
    end

    context 'for a blank value' do
      let(:value) { '' }
      it { expect(title).to eq('Check when to disclose cautions or convictions - GOV.UK') }
    end

    context 'for a provided value' do
      let(:value) { 'Test page' }
      it { expect(title).to eq('Test page - Check when to disclose cautions or convictions - GOV.UK') }
    end
  end

  describe '#fallback_title' do
    before do
      allow(Rails).to receive_message_chain(:application, :config, :consider_all_requests_local).and_return(false)
      allow(helper).to receive(:controller_name).and_return('my_controller')
      allow(helper).to receive(:action_name).and_return('an_action')
    end

    it 'should notify in Sentry about the missing translation' do
      expect(Raven).to receive(:capture_exception).with(
        StandardError.new('page title missing: my_controller#an_action')
      )
      helper.fallback_title
    end

    it 'should call #title with a blank value' do
      expect(helper).to receive(:title).with('')
      helper.fallback_title
    end
  end

  describe '#link_button' do
    it 'builds the link markup styled as a button' do
      expect(
        helper.link_button(:start_again, root_path)
      ).to eq('<a class="govuk-button" data-module="govuk-button" href="/">New check</a>')
    end
  end

  describe '#allow_to_cancel_check?' do
    let(:disclosure_report) { instance_double(DisclosureReport) }
    let(:disclosure_checks) { double('result_set', completed: checks) }

    before do
      allow(disclosure_report).to receive(:disclosure_checks).and_return(disclosure_checks)
      allow(helper).to receive(:current_disclosure_report).and_return(disclosure_report)
    end

    context 'for no checks completed' do
      let(:checks) { [] }
      it { expect(helper.allow_to_cancel_check?).to eq(false) }
    end

    context 'for at least one check completed' do
      let(:checks) { [1] }
      it { expect(helper.allow_to_cancel_check?).to eq(true) }
    end
  end

  describe 'dev_tools_enabled?' do
    before do
      allow(Rails).to receive_message_chain(:env, :development?).and_return(development_env)
      allow(ENV).to receive(:key?).with('DEV_TOOLS_ENABLED').and_return(dev_tools_enabled)
    end

    context 'for development envs' do
      let(:development_env) { true }
      let(:dev_tools_enabled) { nil }

      it { expect(helper.dev_tools_enabled?).to eq(true) }
    end

    context 'for envs that declare the `DEV_TOOLS_ENABLED` env variable' do
      let(:development_env) { false }
      let(:dev_tools_enabled) { true }

      it { expect(helper.dev_tools_enabled?).to eq(true) }
    end

    context 'for envs without `DEV_TOOLS_ENABLED` env variable' do
      let(:development_env) { false }
      let(:dev_tools_enabled) { false }

      it { expect(helper.dev_tools_enabled?).to eq(false) }
    end
  end
end
