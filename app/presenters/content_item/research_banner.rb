module ContentItem
  module ResearchBanner
    USER_RESEARCH_SURVEY_URL = "https://gdsuserresearch.optimalworkshop.com/treejack/ct80d1d6".freeze
    SURVEY_URL_MAPPINGS = {
      "/cost-of-living" => USER_RESEARCH_SURVEY_URL,
      "/guidance/cost-of-living-payment" => USER_RESEARCH_SURVEY_URL,
      "/cost-living-help-local-council" => USER_RESEARCH_SURVEY_URL,
      "/benefits-calculators" => USER_RESEARCH_SURVEY_URL,
      "/the-warm-home-discount-scheme" => USER_RESEARCH_SURVEY_URL,
      "/universal-credit" => USER_RESEARCH_SURVEY_URL,
      "/universal-credit/eligibility" => USER_RESEARCH_SURVEY_URL,
      "/universal-credit/what-youll-get" => USER_RESEARCH_SURVEY_URL,
      "/universal-credit/how-to-claim" => USER_RESEARCH_SURVEY_URL,
      "/universal-credit/other-financial-support" => USER_RESEARCH_SURVEY_URL,
      "/universal-credit/contact-universal-credit" => USER_RESEARCH_SURVEY_URL,
      "/new-state-pension/what-youll-get" => USER_RESEARCH_SURVEY_URL,
      "/get-help-energy-bills" => USER_RESEARCH_SURVEY_URL,
      "/get-help-energy-bills/getting-discount-energy-bill" => USER_RESEARCH_SURVEY_URL,
      "/pension-credit" => USER_RESEARCH_SURVEY_URL,
    }.freeze

    def survey_url
      SURVEY_URL_MAPPINGS[requested_path]
    end
  end
end
