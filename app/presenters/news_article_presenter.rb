class NewsArticlePresenter < ContentItemPresenter
  include ContentItem::Body
  include ContentItem::Political
  include ContentItem::Linkable
  include ContentItem::Updatable
  include ContentItem::Shareable
  include ContentItem::HeadingAndContext
  include ContentItem::Metadata
  include ContentItem::NewsImage
end
