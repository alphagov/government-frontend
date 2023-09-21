module ContentItem
  module RecruitmentBanner
    BRAND_SURVEY_URL = "https://surveys.publishing.service.gov.uk/s/5G06FO/".freeze
    SURVEY_URL_MAPPINGS = {
      "/repaying-your-student-loan" => BRAND_SURVEY_URL,
      "/student-finance" => BRAND_SURVEY_URL,
      "/jobseekers-allowance" => BRAND_SURVEY_URL,
    }.freeze

    def recruitment_survey_url
      brand_user_research_test_url
    end

    def brand_user_research_test_url
      key = content_item["base_path"]
      SURVEY_URL_MAPPINGS[key]
    end
  end
end
