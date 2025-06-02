class WebchatPresenter < ContentItemPresenter
  def initialize(*args)
    super
  end

  def page_title
    "Testing"
  end

  def parsed_content_item
    content_item
  end
end
