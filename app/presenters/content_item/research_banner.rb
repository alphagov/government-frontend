module ContentItem
  module ResearchBanner
    END_OF_LIFE_SURVEY_URL = "https://forms.office.com/e/a0WvT73tCV".freeze
    END_OF_LIFE_BANNER_TEXT = "Help improve this GOV.UK page".freeze

    SURVEY_URL_MAPPINGS = {
      "/benefits-end-of-life" => {
        "text" => END_OF_LIFE_BANNER_TEXT,
        "url" => END_OF_LIFE_SURVEY_URL,
      },
      "/pip/claiming-if-you-might-have-12-months-or-less-to-live" => {
        "text" => END_OF_LIFE_BANNER_TEXT,
        "url" => END_OF_LIFE_SURVEY_URL,
      },
    }.freeze

    def show_research_banner?
      SURVEY_URL_MAPPINGS.key?(requested_path)
    end

    def survey_details
      SURVEY_URL_MAPPINGS[requested_path]
    end
  end
end
