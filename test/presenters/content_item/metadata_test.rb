require "test_helper"

class ContentItemMetadataTest < ActiveSupport::TestCase
  class DummyContentItem
    include ContentItem::Metadata
    attr_reader :content_item, :view_context, :base_path, :public_updated_at, :title, :schema_name

    def initialize(schema_name = "manual")
      @view_context = ApplicationController.new.view_context
      @content_item = {
        "title" => "Super title",
        "base_path" => "/a/base/path",
        "public_updated_at" => "2022-03-23T08:30:20.000+00:00",
        "first_published_at" => "2000-03-23T08:30:20.000+00:00",
        "schema_name" => schema_name,
        "details" => {
          "body" => "body",
          "child_section_groups" => [{ "title" => "thing" }],
          "display_date" => "23 March 2000",
        },
        "links" => {
          "organisations" => [
            { "content_id" => SecureRandom.uuid, "title" => "blah", "base_path" => "/blah" },
          ],
        },
      }
      @base_path = content_item["base_path"]
      @public_updated_at = content_item["public_updated_at"]
      @title = content_item["title"]
      @schema_name = content_item["schema_name"]
    end
  end

  test "returns see_updates_link true if published" do
    item = DummyContentItem.new

    expected_publisher_metadata = {
      from: ["<a class=\"govuk-link\" href=\"/blah\">blah</a>"],
      first_published: "23 March 2000",
      last_updated: "23 March 2022",
      see_updates_link: true,
    }

    assert_equal expected_publisher_metadata, item.publisher_metadata
  end

  test "does not return see_updates_link if pending" do
    item = DummyContentItem.new
    item.content_item["details"]["display_date"] = "23 March 3000"

    expected_publisher_metadata = {
      from: ["<a class=\"govuk-link\" href=\"/blah\">blah</a>"],
      first_published: "23 March 2000",
      last_updated: "23 March 2022",
    }

    assert_equal expected_publisher_metadata, item.publisher_metadata
  end
end
