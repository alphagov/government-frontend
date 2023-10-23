module ContentItem
  module RecruitmentBanner
    def recruitment_survey_details
      survey_pages = YAML.load_file(Rails.root.join("config/recruitment_banner_pages.yml"))
      key = content_item["base_path"]

      # TODO: check if all the values are in place
      # TODO: if the text is not specified in the yml, we should use the standard one
      survey_pages.find{ |banner| banner["pages"].include?(key) } if survey_pages
    end
  end
end
