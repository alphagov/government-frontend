class ServiceManualGuidePresenter
  include ActionView::Helpers::DateHelper
  attr_reader :content_item, :title, :body, :format, :locale, :publish_time, :header_links

  def initialize(content_item)
    @content_item = content_item

    @title = content_item["title"]
    @body = content_item["details"]["body"]
    @header_links = Array(content_item["details"]["header_links"])
                      .map{ |h| ActiveSupport::HashWithIndifferentAccess.new(h) }
    @format = content_item["format"]
  end

  def last_updated_ago_in_words
    "#{time_ago_in_words(updated_at)} ago"
  end

  def last_update_timestamp
    updated_at.strftime("%e %B %Y %H:%M")
  end

private

  def updated_at
    DateTime.parse(content_item["public_updated_at"])
  end
end
