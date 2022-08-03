module ContentItem
  module RecruitmentBanner
    TREE_TEST_URL = "https://GDSUserResearch.optimalworkshop.com/treejack/834dm2s6".freeze
    TREE_TEST_PAGE = "/browse/working".freeze
    TREE_TEST_MAPPINGS = { TREE_TEST_PAGE => TREE_TEST_URL }.freeze

    def recruitment_survey_url
      tree_test_url
    end

    def tree_test_url
      key = TREE_TEST_MAPPINGS.keys.find { |k| content_tagged_to(k).present? }
      TREE_TEST_MAPPINGS[key]
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
