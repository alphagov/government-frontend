module Navigation
  module SpecialistDocuments
    include Finders

    PARAMS_TO_IGNORE = %w(
      bulk_published
      opened_date
      closed_date
      date_of_occurrence
    ).freeze

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
        .except(*PARAMS_TO_IGNORE)
        .to_query
    end

    def pluralised_document_type
      I18n.t("content_item.schema_name.#{document_type}", count: 2, locale: :en)
    end
  end
end
