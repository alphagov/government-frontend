class FieldsOfOperationPresenter < ContentItemPresenter
  include ContentItem::TitleAndContext

  def fields_of_operation
    content_item.dig("links", "fields_of_operation").map { |field| [field["title"], field["base_path"]] }
  end

  def title_and_context
    super.tap do |t|
      t[:context] = "British fatalities"
      t.delete(:average_title_length)
    end
  end
end
