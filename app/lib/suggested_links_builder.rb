class SuggestedLinksBuilder
  def initialize(content_item)
    @content_item = content_item
  end

  def suggested_related_links
    @content_item["links"].fetch("suggested_ordered_related_items", [])
  end

  def weighted_related_links
    weighted_page = WeightedLinksPage.find_page_with_base_path(@content_item["base_path"])

    if weighted_page
      weighted_page.related_links.map do |link|
        Services.content_store.content_item(link)
      end
    end
  end

private

  attr_reader :content_item
end
