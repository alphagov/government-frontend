module ContentItem
  module RecruitmentBanner
    def recruitment_survey_url
      pages = YAML.load_file(Rails.root.join("config/recruitment_banner_pages.yml"))
      key = content_item["base_path"]

      pages[key] if pages
    end
  end
end
