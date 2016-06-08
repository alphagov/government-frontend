class CaseStudyPresenter < ContentItemPresenter
  include ActionView::Helpers::UrlHelper
  include Linkable
  include Updatable

  attr_reader :body

  def initialize(content_item)
    super
    @body = content_item["details"]["body"]
  end

  def image
    content_item["details"]["image"]
  end
end
