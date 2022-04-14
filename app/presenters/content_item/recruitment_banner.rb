module ContentItem
  module RecruitmentBanner
    SURVEY_URL_ONE = "https://surveys.publishing.service.gov.uk/s/GY8Q11".freeze
    SURVEY_URLS = {
      "/browse/tax" => SURVEY_URL_ONE,
      "/browse/business" => SURVEY_URL_ONE,
    }.freeze

    def recruitment_survey_url
      key = SURVEY_URLS.keys.find { |k| content_tagged_to(k).present? }
      SURVEY_URLS[key]
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