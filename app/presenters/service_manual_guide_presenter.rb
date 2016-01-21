class ServiceManualGuidePresenter < ContentItemPresenter
  ContentOwner = Struct.new(:title, :href)
  RelatedDiscussion = Struct.new(:title, :href)

  include ActionView::Helpers::DateHelper
  attr_reader :body, :publish_time, :header_links

  def initialize(content_item)
    super
    @body = content_item["details"]["body"]
    @header_links = Array(content_item["details"]["header_links"])
                      .map{ |h| ActiveSupport::HashWithIndifferentAccess.new(h) }
  end

  def content_owner
    content_owner_data = content_item["details"]["content_owner"]
    ContentOwner.new(content_owner_data["title"], content_owner_data["href"])
  end

  def related_discussion
    if content_item["details"]["related_discussion"]
      discussion_data = content_item["details"]["related_discussion"]
      RelatedDiscussion.new(discussion_data['title'], discussion_data['href'])
    end
  end

  def last_updated_ago_in_words
    "#{time_ago_in_words(updated_at)} ago"
  end

  def last_update_timestamp
    updated_at.strftime("%e %B %Y %H:%M")
  end

  def main_topic
    @main_topic ||= Array(content_item.links.topics).first
  end
private

  def updated_at
    DateTime.parse(content_item["public_updated_at"])
  end
end
