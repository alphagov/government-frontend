class CaseStudyPresenter < ContentItemPresenter
  include ActionView::Helpers::UrlHelper
  include Linkable
  include Updatable
  include Withdrawable

  attr_reader :body, :format_display_type

  def initialize(content_item)
    super
    @body = content_item["details"]["body"]
    @format_display_type = content_item["details"]["format_display_type"]
  end

  def image
    content_item["details"]["image"]
  end
end
