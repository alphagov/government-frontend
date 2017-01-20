class StatisticalDataSetPresenter < ContentItemPresenter
  include ContentsList
  include TitleAndContext
  include Political
  include Metadata

  def body
    content_item["details"]["body"]
  end
end
