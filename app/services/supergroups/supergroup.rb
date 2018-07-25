class Supergroup
  def initialize(content_item, name)
    @content_item = content_item
    @name = name
  end

  def content
    @content ||= fetch_content
  end

private

  def fetch_content
    return [] unless taxon_content_ids.any?
    content_class.new(content_ids: taxon_content_ids, filter_content_purpose_supergroup: @name).fetch
  end

  def content_class
    MostPopularContent
  end

  def taxon_content_ids
    return [] unless @content_item.dig("links", "taxons")
    @content_item["links"]["taxons"].map { |taxon| taxon["content_id"] }
  end
end
