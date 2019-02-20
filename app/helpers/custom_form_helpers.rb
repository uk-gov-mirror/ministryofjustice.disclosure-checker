module CustomFormHelpers
  delegate :t, to: :@template

  def continue_button(continue: :continue)
    content_tag(:div, class: 'form-submit') do
      submit_button(continue)
    end
  end

  private

  def submit_button(i18n_key, opts = {})
    submit t("helpers.submit.#{i18n_key}"), {class: 'govuk-button'}.merge(opts)
  end
end
