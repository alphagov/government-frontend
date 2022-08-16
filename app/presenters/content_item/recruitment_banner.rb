module ContentItem
  module RecruitmentBanner
    VISA_TEST_URL = "https://surveys.publishing.service.gov.uk/s/0DZCPX/".freeze
    VISA_TEST_MAPPINGS = {
      "/apply-to-come-to-the-uk" => VISA_TEST_URL,
      "/healthcare-immigration-application" => VISA_TEST_URL,
      "/tb-test-visa" => VISA_TEST_URL,
      "/faster-decision-visa-settlement" => VISA_TEST_URL,
      "/skilled-worker-visa" => VISA_TEST_URL,
      "/health-care-worker-visa" => VISA_TEST_URL,
      "/temporary-worker-charity-worker-visa" => VISA_TEST_URL,
      "/seasonal-worker-visa" => VISA_TEST_URL,
      "/graduate-visa" => VISA_TEST_URL,
      "/uk-family-visa" => VISA_TEST_URL,
      "/find-a-visa-application-centre" => VISA_TEST_URL,
      "/guidance/visa-decision-waiting-times-applications-outside-the-uk" => VISA_TEST_URL,
      "/government/publications/skilled-worker-visa-shortage-occupations/skilled-worker-visa-shortage-occupations" => VISA_TEST_URL,
    }.freeze

    def recruitment_survey_url
      visa_test_url
    end

    def visa_test_url
      key = content_item["base_path"]
      VISA_TEST_MAPPINGS[key]
    end
  end
end
