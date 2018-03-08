class NavigationType
  def initialize(content_item)
    @content_item = content_item
  end

  def should_present_taxonomy_navigation?
    !content_is_tagged_to_browse_pages? &&
      content_is_tagged_to_a_taxon?
  end

private

  def content_is_tagged_to_a_taxon?
    @content_item.dig("links", "taxons").present?
  end

  def content_is_tagged_to_browse_pages?
    @content_item.dig("links", "mainstream_browse_pages").present?
  end
end
