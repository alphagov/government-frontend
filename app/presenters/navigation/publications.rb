module Navigation
  module Publications
    include Finders

    def finder_path_and_params
      "/government/publications?#{facet_params}"
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
      option ||= "all"
      { "publication_filter_option" => option }
    end

    def pluralised_document_type
      doctype = I18n.t("content_item.schema_name.#{document_type}", count: 2, locale: :en)
      doctype[0] = doctype[0].downcase unless doctype.match?(/^(National|Official) Statistics$/)
      doctype
    end
  end
end
