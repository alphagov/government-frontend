class StatisticalDataSetPresenter < ContentItemPresenter
  include ContentItem::Body
  include ContentItem::ContentsList
  include ContentItem::TitleAndContext
  include ContentItem::Political
  include ContentItem::Metadata
  include Navigation::Statistics
end
