module ContentItem
  module HeadingAndContext
    def heading_and_context
      {
        text: title,
        context: I18n.t("content_item.schema_name.#{document_type}", count: 1),
        context_locale: view_context.t_locale_fallback("content_item.schema_name.#{document_type}", count: 1),
        heading_level: 1,
        margin_bottom: 8,
        font_size: "l",
      }
    end
  end
end
