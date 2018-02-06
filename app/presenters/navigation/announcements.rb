module Navigation
  module Announcements
    include Finders

    DOCUMENT_TYPE_MAPPINGS = {
      "fatality_notice" => "fatality-notices",
      "news_story" => "news-stories",
    }.freeze

    def finder_path_and_params
      "/government/announcements?#{facet_params}"
    end

    def facet_params
      departments
        .merge(filter_option)
        .merge(people)
        .merge(topics)
        .merge(world_locations).to_query
    end

    def filter_option
      option = content_item["government_document_supertype"]
      option ||= DOCUMENT_TYPE_MAPPINGS.fetch(content_item["document_type"], "all")
      { "announcement_filter_option" => option }
    end

    def pluralised_document_type
      doctype = I18n.t("content_item.schema_name.#{document_type}", count: 2, locale: :en)
      doctype[0] = doctype[0].downcase
      doctype
    end
  end
end
