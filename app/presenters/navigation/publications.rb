module Navigation
  module Publications
    include Finders

    STATISTICS_DOCTYPES = %w(national_statistics official_statistics).freeze

    def finder_path_and_params
      "/government/publications?#{facet_params}"
    end

    def facet_params
      departments
        .merge(filter_option)
        .merge(topics).to_query
    end

    def filter_option
      option = content_item["government_document_supertype"]
      option ||= "all"
      { "publication_filter_option" => option }
    end

    def pluralised_document_type
      return "Statistics" if STATISTICS_DOCTYPES.include?(document_type)
      return "FOI releases" if document_type == "foi_release"

      doctype = I18n.t("content_item.schema_name.#{document_type}", count: 2, locale: :en)
      doctype[0] = doctype[0].downcase
      doctype
    end
  end
end
