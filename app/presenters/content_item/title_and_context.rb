module ContentItem
  module TitleAndContext
    def title_and_context
      {
        title:,
        context: I18n.t("content_item.schema_name.#{document_type}", count: 1),
        context_locale: view_context.t_locale_fallback("content_item.schema_name.#{document_type}", count: 1),
        average_title_length: "long",
      }
    end
  end
end
