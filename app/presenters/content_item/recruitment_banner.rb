module ContentItem
  module RecruitmentBanner
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

    def benefits_recruitment_survey_url
      key = content_item["base_path"]
      BENEFITS_SURVEY_URL_MAPPINGS[key]
    end
  end
end
