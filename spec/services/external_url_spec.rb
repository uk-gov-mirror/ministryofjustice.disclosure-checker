require 'spec_helper'

RSpec.describe ExternalUrl do
  describe '.govuk_check_your_conviction_caution_url' do
    it 'has the correct url' do
      expect(described_class.govuk_check_your_conviction_caution_url).to eq(
        'https://www.gov.uk/tell-employer-or-college-about-criminal-record/check-your-conviction-caution'
      )
    end
  end
end
