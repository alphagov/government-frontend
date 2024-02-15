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

  test "presents the document image if present" do
    item = DummyContentItem.new
    image = { "url" => "http://www.test.dev.gov.uk/lead_image.jpg" }
    item.content_item["details"]["image"] = image

    assert_equal image, item.image
  end

  test "presents the first primary publishing organisation default_news_image if document image is not present" do
    item = DummyContentItem.new
    default_news_image = { "url" => "http://www.test.dev.gov.uk/primary_publishing_organisation_default_news_image.jpg" }
    item.content_item["links"]["primary_publishing_organisation"] = [
      "details" => { "default_news_image" => default_news_image },
    ]

    assert_equal default_news_image, item.image
  end

  test "presents the first worldwide_organisation default_news_image if the document image is not present" do
    item = DummyContentItem.new
    item.content_item["document_type"] = "world_news_story"
    default_news_image = { "url" => "http://www.test.dev.gov.uk/worldwide_organisation_default_news_image.jpg" }
    item.content_item["links"]["worldwide_organisations"] = [
      "details" => { "default_news_image" => default_news_image },
    ]

    assert_equal default_news_image, item.image
  end

  test "presents the correct placeholder image if document has no image or default news image" do
    item = DummyContentItem.new
    expected_placeholder_image = { "url" => "https://assets.publishing.service.gov.uk/media/5e59279b86650c53b2cefbfe/placeholder.jpg" }

    assert_equal expected_placeholder_image, item.image
  end

  test "presents the correct placeholder image if a world_news_story has no image or default news image" do
    item = DummyContentItem.new
    item.content_item["document_type"] = "world_news_story"

    expected_placeholder_image = { "url" => "https://assets.publishing.service.gov.uk/media/5e985599d3bf7f3fc943bbd8/UK_government_logo.jpg" }

    assert_equal expected_placeholder_image, item.image
  end
end
