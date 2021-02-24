class ExternalUrl
  GOVUK_TELL_EMPLOYER_EXTERNAL_URL = 'https://www.gov.uk/tell-employer-or-college-about-criminal-record/check-your-conviction-caution'.freeze

  class << self
    def govuk_check_your_conviction_caution_url
      GOVUK_TELL_EMPLOYER_EXTERNAL_URL
    end
  end
end
