module ContentItem
  module BrexitTaxons
    BREXIT_BUSINESS_PAGE_CONTENT_ID = "91cd6143-69d5-4f27-99ff-a52fb0d51c78".freeze
    BREXIT_BUSINESS_PAGE_PATH = "/guidance/brexit-guidance-for-businesses".freeze

    BREXIT_CITIZEN_PAGE_CONTENT_ID = "6555e0bf-c270-4cf9-a0c5-d20b95fab7f1".freeze
    BREXIT_CITIZEN_PAGE_PATH = "/guidance/brexit-guidance-for-individuals-and-families".freeze

    def brexit_child_taxons
      {
        BREXIT_BUSINESS_PAGE_CONTENT_ID => {
          nav_link: {
            text: I18n.t("brexit.citizen_link"),
            path: BREXIT_CITIZEN_PAGE_PATH,
            track_label: "Guidance nav link",
          },
          track_category: "brexit-business-page",
        },
        BREXIT_CITIZEN_PAGE_CONTENT_ID => {
          nav_link: {
            text: I18n.t("brexit.business_link"),
            path: BREXIT_BUSINESS_PAGE_PATH,
            track_label: "Guidance nav link",

          },
          track_category: "brexit-citizen-page",
        },
      }
    end

    def brexit_child_taxon
      brexit_child_taxons[content_item["content_id"]]
    end
  end
end
