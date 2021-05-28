module ContentItem
  module BrexitHubPage
    BREXIT_BUSINESS_PAGE_CONTENT_ID = "91cd6143-69d5-4f27-99ff-a52fb0d51c78".freeze
    BREXIT_CITIZEN_PAGE_CONTENT_ID = "6555e0bf-c270-4cf9-a0c5-d20b95fab7f1".freeze
    BREXIT_HUB_PAGE_CONTENT_IDS = [BREXIT_BUSINESS_PAGE_CONTENT_ID, BREXIT_CITIZEN_PAGE_CONTENT_ID].freeze
    BREXIT_BUSINESS_PAGE_PATH = "/guidance/brexit-guidance-for-businesses".freeze
    BREXIT_CITIZEN_PAGE_PATH = "/guidance/brexit-guidance-for-individuals-and-families".freeze

    def brexit_links
      {
        ContentItem::BrexitHubPage::BREXIT_BUSINESS_PAGE_CONTENT_ID => {
          text: I18n.t("brexit.citizen_link"),
          path: BREXIT_CITIZEN_PAGE_PATH,
        },
        ContentItem::BrexitHubPage::BREXIT_CITIZEN_PAGE_CONTENT_ID => {
          text: I18n.t("brexit.business_link"),
          path: BREXIT_BUSINESS_PAGE_PATH,
        },
      }
    end

    def brexit_link
      brexit_links[content_item.dig("content_id")]
    end
  end
end
