module ContentItem
  module RecruitmentBanner
    SURVEY_URL = "https://surveys.publishing.service.gov.uk/s/SNFVW1/".freeze
    SURVEY_URL_MAPPINGS = {
      "/log-in-register-hmrc-online-services" => SURVEY_URL,
      "/log-in-file-self-assessment-tax-return" => SURVEY_URL,
      "/self-assessment-tax-returns" => SURVEY_URL,
      "/pay-self-assessment-tax-bill" => SURVEY_URL,
      "/contact-hmrc" => SURVEY_URL,
      "/log-in-register-hmrc-online-services/register" => SURVEY_URL,
      "/dbs-update-service" => SURVEY_URL,
      "/government/organisations/hm-revenue-customs/contact/self-assessment" => SURVEY_URL,
    }.freeze

    def recruitment_survey_url
      user_research_test_url
    end

    def user_research_test_url
      key = content_item["base_path"]
      SURVEY_URL_MAPPINGS[key]
    end
  end
end
