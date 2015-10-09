class ShortTextPresenter
  attr_reader :content_item, :title, :body, :format, :locale, :publish_time

  def initialize(content_item)
    @content_item = content_item

    @title = content_item["title"]
    @body = content_item["details"]["body"]
    @format = content_item["format"]
  end
end
