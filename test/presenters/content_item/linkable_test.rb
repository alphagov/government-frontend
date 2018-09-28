require 'test_helper'

class ContentItemLinkableTest < ActiveSupport::TestCase
  class DummyContentItem
    include ContentItem::Linkable
    attr_accessor :content_item, :title

    def initialize
      @content_item = {
        "base_path" => "/a/base/path",
        "links" => {},
      }
      @title = "A Title"
    end
  end

  test "when people links have base_paths they are linked to" do
    item = DummyContentItem.new
    item.content_item["links"]["people"] = [
      {
        "title" => "Winston Churchill",
        "base_path" => "/government/people/winston-churchill",
      }
    ]

    expected_from_links = [
      %{<a href="/government/people/winston-churchill">Winston Churchill</a>}
    ]
    assert_equal expected_from_links, item.from
  end

  test "when people links don't have base_paths they are skipped" do
    item = DummyContentItem.new
    item.content_item["links"]["people"] = [
      {
        "title" => "Winston Churchill",
        "base_path" => nil,
      }
    ]

    expected_from_links = []
    assert_equal expected_from_links, item.from
  end

  # World locations don't have links in the Publishing API payload
  # This weird situation is explained here:
  # - https://github.com/alphagov/government-frontend/pull/386
  test "when a world location is linked to" do
    item = DummyContentItem.new
    item.content_item["links"]["world_locations"] = [
      {
        "title" => "Germany",
        "base_path" => nil,
      }
    ]

    expected_from_links = [
      %{<a href="/world/germany/news">Germany</a>}
    ]
    assert_equal expected_from_links, item.part_of
  end
end
