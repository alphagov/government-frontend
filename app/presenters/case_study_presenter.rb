class CaseStudyPresenter < ContentItemPresenter
  include Metadata

  def body
    content_item['details']['body']
  end

  def image
    content_item["details"]["image"]
  end
end
