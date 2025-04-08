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

    def text_direction
      "ltr"
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

  test "metadata see_updates_link is true when there are updates" do
    item_with_updates = DummyContentItem.new

    assert item_with_updates.metadata[:see_updates_link]
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

  test "does not return see_updates_link if cancelled" do
    item = DummyContentItem.new
    item.content_item["details"]["state"] = "cancelled"

    assert item.cancelled_stats_announcement?
  end

  test "cancelled_stats_announcement? returns false when state is not cancelled" do
    item = DummyContentItem.new

    item.content_item["details"]["state"] = "published"
    assert_not item.cancelled_stats_announcement?
  end

  class MockUpdatableItem < DummyContentItem
    def initialize(has_updates: true)
      super()
      @has_updates = has_updates
    end

    def any_updates?
      @has_updates
    end
  end

  test "metadata see_updates_link reflects any_updates? result" do
    item_with_updates = MockUpdatableItem.new(has_updates: true)
    assert item_with_updates.metadata[:see_updates_link]
    item_without_updates = MockUpdatableItem.new(has_updates: false)
    assert_not item_without_updates.metadata[:see_updates_link]
  end
end
