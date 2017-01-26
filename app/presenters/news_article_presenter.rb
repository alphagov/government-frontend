class NewsArticlePresenter < ContentItemPresenter
  include Political
  include Linkable
  include Updatable
  include Shareable
  include TitleAndContext
  include Metadata

  def body
    content_item["details"]["body"]
  end

  def image
    content_item["details"]["image"]
  end
end
