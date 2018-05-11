class NewsArticlePresenter < ContentItemPresenter
  include ContentItem::Body
  include ContentItem::Political
  include ContentItem::Linkable
  include ContentItem::Updatable
  include ContentItem::Shareable
  include ContentItem::TitleAndContext
  include ContentItem::Metadata

  def image
    content_item["details"]["image"]
  end

  def structured_data
    SchemaOrg::NewsArticleSchema.new(self).structured_data
  end
end
