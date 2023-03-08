module ContentItem
  module CostOfLivingBanner
    COST_OF_LIVING_SURVEY_URL = "https://s.userzoom.com/m/MSBDMTQ3MVM0NCAg".freeze

    SURVEY_URL_MAPPINGS = {
      "/guidance/cost-of-living-payment" => COST_OF_LIVING_SURVEY_URL,
      "/cost-living-help-local-council" => COST_OF_LIVING_SURVEY_URL,
      "/benefits-calculators" => COST_OF_LIVING_SURVEY_URL,
      "/the-warm-home-discount-scheme" => COST_OF_LIVING_SURVEY_URL,
      "/universal-credit" => COST_OF_LIVING_SURVEY_URL,
      "/universal-credit/eligibility" => COST_OF_LIVING_SURVEY_URL,
      "/universal-credit/what-youll-get" => COST_OF_LIVING_SURVEY_URL,
      "/universal-credit/how-to-claim" => COST_OF_LIVING_SURVEY_URL,
      "/universal-credit/other-financial-support" => COST_OF_LIVING_SURVEY_URL,
      "/universal-credit/contact-universal-credit" => COST_OF_LIVING_SURVEY_URL,
      "/new-state-pension/what-youll-get" => COST_OF_LIVING_SURVEY_URL,
      "/get-help-energy-bills" => COST_OF_LIVING_SURVEY_URL,
      "/get-help-energy-bills/getting-discount-energy-bill" => COST_OF_LIVING_SURVEY_URL,
      "/pension-credit" => COST_OF_LIVING_SURVEY_URL,
    }.freeze

    def survey_url
      cost_of_living_test_url
    end

    def cost_of_living_test_url
      key = content_item["base_path"]
      SURVEY_URL_MAPPINGS[key]
    end
  end
end
