class NavigationType
  NEW_NAVIGATION_CONTENT_ITEM_SCHEMAS =
    %w{answer contact guide detailed_guide document_collection publication}.freeze

  def initialize(content_item)
    @content_item = content_item
  end

  def should_present_new_navigation_view?
    content_is_tagged_to_a_taxon? && content_schema_has_new_navigation?
  end

private

  def content_is_tagged_to_a_taxon?
    @content_item.dig("links", "taxons").present?
  end

  def content_schema_has_new_navigation?
    NEW_NAVIGATION_CONTENT_ITEM_SCHEMAS.include? @content_item["schema_name"]
  end
end
