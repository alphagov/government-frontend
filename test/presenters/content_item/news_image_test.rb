require "test_helper"

class ContentItemNewsImageTest < ActiveSupport::TestCase
  class DummyContentItem
    include ContentItem::NewsImage
    attr_accessor :content_item

    def initialize
      @content_item = {
        "base_path" => "/a/base/path",
        "details" => {},
        "links" => {},
      }
    end
  end

  test "presents the document's image if present" do
    item = DummyContentItem.new
    image = { "url" => "http://www.test.dev.gov.uk/lead_image.jpg" }
    item.content_item["details"]["image"] = image

    assert_equal image, item.image
  end

  test "presents the document's organisation's default_news_image if document's image is not present" do
    item = DummyContentItem.new
    default_news_image = { "url" => "http://www.test.dev.gov.uk/default_news_image.jpg" }
    item.content_item["links"]["primary_publishing_organisation"] = [
      "details" => { "default_news_image" => default_news_image },
    ]

    assert_equal default_news_image, item.image
  end

  test "presents a placeholder image if document has no image or default news image" do
    item = DummyContentItem.new
    placeholder_image = { "url" => "https://assets.publishing.service.gov.uk/government/assets/placeholder.jpg" }

    assert_equal placeholder_image, item.image
  end
end
