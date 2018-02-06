module Navigation
  module SpecialistDocuments
    include Finders

    def finder_path_and_params
      "#{finder_path}?#{facet_params}"
    end

    def finder_path
      finder["base_path"] if finder
    end

    def finder
      finders = content_item["links"]["finder"]
      finders.first
    end

    def facet_params
      content_item["details"]["metadata"]
        .each_value { |v| v.try(:sort!) }
        .except(*params_to_ignore)
        .to_query
    end

    def params_to_ignore
      %w(bulk_published) + date_facet_keys
    end

    def date_facet_keys
      return [] unless finder
      finder_details = finder.fetch("details", {})
      finder_details.fetch("facets", {}).map { |f| f["key"] if f["type"] == "date" }.compact
    end

    def pluralised_document_type
      I18n.t("content_item.schema_name.#{document_type}", count: 2, locale: :en)
    end
  end
end
