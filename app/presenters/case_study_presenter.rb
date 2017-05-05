class CaseStudyPresenter < ContentItemPresenter
  include Body
  include Metadata
  include TitleAndContext

  def image
    content_item["details"]["image"]
  end
end
