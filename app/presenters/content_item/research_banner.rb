module ContentItem
  module ResearchBanner
    END_OF_LIFE_SURVEY_URL = "https://forms.office.com/e/a0WvT73tCV".freeze

    SURVEY_URL_MAPPINGS = {
      "/benefits-end-of-life" => END_OF_LIFE_SURVEY_URL,
      "/pip/claiming-if-you-might-have-12-months-or-less-to-live" => END_OF_LIFE_SURVEY_URL,
    }.freeze

    def survey_url
      SURVEY_URL_MAPPINGS[requested_path]
    end
  end
end
