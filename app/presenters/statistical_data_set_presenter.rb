class StatisticalDataSetPresenter < ContentItemPresenter
  include ContentItem::Body
  include ContentItem::ContentsList
  include ContentItem::TitleAndContext
  include ContentItem::Political
  include ContentItem::Metadata

  def structured_data
    # TODO: implement a schema
    {}
  end
end
