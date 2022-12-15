module ContentItem
  module RecruitmentBanner
    COST_OF_LIVING_SURVEY_URL = "https://GDSUserResearch.optimalworkshop.com/treejack/cbd7a696cbf57c683cbb2e95b4a36c8a".freeze
    SURVEY_URL_MAPPINGS = {
      "/guidance/cost-of-living-payment" => COST_OF_LIVING_SURVEY_URL,
      "/universal-credit" => COST_OF_LIVING_SURVEY_URL,
      "/the-warm-home-discount-scheme" => COST_OF_LIVING_SURVEY_URL,
      "/winter-fuel-payment" => COST_OF_LIVING_SURVEY_URL,
      "/pay-self-assessment-tax-bill" => COST_OF_LIVING_SURVEY_URL,
      "/universal-credit/eligibility" => COST_OF_LIVING_SURVEY_URL,
      "/universal-credit/what-youll-get" => COST_OF_LIVING_SURVEY_URL,
      "/universal-credit/how-to-claim" => COST_OF_LIVING_SURVEY_URL,
      "/winter-fuel-payment/how-much-youll-get" => COST_OF_LIVING_SURVEY_URL,
      "/government/publications/autumn-statement-2022-cost-of-living-support-factsheet/cost-of-living-support-factsheet" => COST_OF_LIVING_SURVEY_URL,
      "/new-state-pension/what-youll-get" => COST_OF_LIVING_SURVEY_URL,
      "/check-if-youre-eligible-for-warm-home-discount" => COST_OF_LIVING_SURVEY_URL,
      "/universal-credit/other-financial-support" => COST_OF_LIVING_SURVEY_URL,
      "/guidance/getting-the-energy-bills-support-scheme-discount" => COST_OF_LIVING_SURVEY_URL,
      "/pension-credit" => COST_OF_LIVING_SURVEY_URL,
      "/child-benefit" => COST_OF_LIVING_SURVEY_URL,
    }.freeze

    def recruitment_survey_url
      cost_of_living_test_url
    end

    def cost_of_living_test_url
      key = content_item["base_path"]
      SURVEY_URL_MAPPINGS[key]
    end
  end
end
