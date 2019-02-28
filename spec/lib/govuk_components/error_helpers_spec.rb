require 'rails_helper'

RSpec.describe GovukElementsErrorsHelper do
  def strip_text(text)
    text = text.strip.split("\n").map(&:strip)
    text.delete_if { |line| line == '' }
    text.join
  end

  # Note: This is just a very broad and `happy path` test.
  # It is also coupled to current i18n so, if the strings change,
  # then the HTML fixture will need to also be updated.
  #
  describe '.error_summary' do
    let(:disclosure_check) { DisclosureCheck.new }
    let(:html_output) { GovukElementsErrorsHelper.error_summary(disclosure_check, 'There is an error') }
    let(:html_fixture) { file_fixture('error_summary.html').read }

    it 'outputs the expected markup' do
      disclosure_check.errors.add(:kind, :inclusion)

      expect(
        strip_text(html_output)
      ).to eq(
        strip_text(html_fixture)
      )
    end
  end
end
