class SuggestedLinksBuilder
  def initialize(content_item)
    @content_item = content_item
  end

  def suggested_related_links
    @content_item["links"].fetch("suggested_ordered_related_items", [])
  end

private

  attr_reader :content_item
end
