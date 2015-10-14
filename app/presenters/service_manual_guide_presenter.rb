class ServiceManualGuidePresenter
  attr_reader :content_item, :title, :body, :format, :locale, :publish_time, :header_links

  def initialize(content_item)
    @content_item = content_item

    @title = content_item["title"]
    @body = content_item["details"]["body"]
    @header_links = content_item["details"]["header_links"]
                      .map{|h| ActiveSupport::HashWithIndifferentAccess.new(h)}
    @format = content_item["format"]
  end
end
