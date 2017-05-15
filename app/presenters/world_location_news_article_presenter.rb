class WorldLocationNewsArticlePresenter < ContentItemPresenter
  include Body
  include Political
  include Linkable
  include Updatable
  include Shareable
  include TitleAndContext
  include Metadata

  def image
    content_item["details"]["image"]
  end
end
