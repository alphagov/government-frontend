module TitleAndContext
  def title_and_context
    {
      title: title,
      context: I18n.t("content_item.schema_name.#{document_type}", count: 1),
      average_title_length: "long"
    }
  end
end
