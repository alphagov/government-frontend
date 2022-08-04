module ContentItem
  module RecruitmentBanner
    TREE_TEST_URL = "https://GDSUserResearch.optimalworkshop.com/treejack/b3cu012d".freeze
    TREE_TEST_PAGE = "/browse/working".freeze
    TREE_TEST_MAPPINGS = { TREE_TEST_PAGE => TREE_TEST_URL }.freeze

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
      tree_test_url || visa_test_url
    end

    def tree_test_url
      key = TREE_TEST_MAPPINGS.keys.find { |k| content_tagged_to(k).present? }
      TREE_TEST_MAPPINGS[key]
    end

    def visa_test_url
      key = content_item["base_path"]
      VISA_TEST_MAPPINGS[key]
    end

  private

    def mainstream_browse_pages
      content_item["links"]["mainstream_browse_pages"] if content_item["links"]
    end

    def content_tagged_to(browse_base_path)
      return [] unless mainstream_browse_pages

      mainstream_browse_pages.find do |mainstream_browse_page|
        mainstream_browse_page["base_path"].starts_with? browse_base_path
      end
    end
  end
end
