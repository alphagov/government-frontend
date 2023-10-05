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

    BENEFITS_SURVEY_URL = "https://signup.take-part-in-research.service.gov.uk/home?utm_campaign=Content_History&utm_source=Hold_gov_to_account&utm_medium=gov.uk&t=GDS&id=16".freeze
    BENEFITS_SURVEY_URL_MAPPINGS = {
      "/disability-living-allowance-children" => BENEFITS_SURVEY_URL,
      "/help-with-childcare-costs" => BENEFITS_SURVEY_URL,
      "/financial-help-disabled" => BENEFITS_SURVEY_URL,
      "/pip" => BENEFITS_SURVEY_URL,
      "/blind-persons-allowance" => BENEFITS_SURVEY_URL,
      "/dla-disability-living-allowance-benefit" => BENEFITS_SURVEY_URL,
      "/carers-allowance" => BENEFITS_SURVEY_URL,
      "/carers-credit" => BENEFITS_SURVEY_URL,
      "/maternity-pay-leave" => BENEFITS_SURVEY_URL,
      "/paternity-pay-leave" => BENEFITS_SURVEY_URL,
      "/child-benefit" => BENEFITS_SURVEY_URL,
      "/jobseekers-allowance" => BENEFITS_SURVEY_URL,
      "/universal-credit" => BENEFITS_SURVEY_URL,
      "/employment-support-allowance" => BENEFITS_SURVEY_URL,
      "/benefits-calculators" => BENEFITS_SURVEY_URL,
    }.freeze

    def recruitment_survey_url
      user_research_test_url
    end

    def benefits_recruitment_survey_url
      key = content_item["base_path"]
      BENEFITS_SURVEY_URL_MAPPINGS[key]
    end

    def user_research_test_url
      key = content_item["base_path"]
      SURVEY_URL_MAPPINGS[key]
    end
  end
end
