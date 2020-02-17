require "test_helper"

class FeaturedAttachmentsMigrationTest < ActiveSupport::TestCase
  class DummyContentItem
    include ContentItem::FeaturedAttachmentsMigration
    attr_accessor :content_item

    def initialize(old_list, new_list)
      @content_item = {
        "base_path" => "/a/base/path",
        "details" => { "old_badness" => old_list, "new_hotness" => new_list }.compact,
        "links" => {},
      }
    end

    def choose
      choose_field(
        old_field_name: "old_badness",
        new_field_name: "new_hotness",
      )
    end
  end

  test "presents the old field if the new one is missing" do
    item = DummyContentItem.new(%w(1 2 3), nil)

    assert_equal %w(1 2 3), item.choose
  end

  test "presents the old field if the new one is a different size" do
    item = DummyContentItem.new(%w(1 2 3), %w(foo bar baz bat))

    assert_equal %w(1 2 3), item.choose
  end

  test "presents the new field if present and the old one is the same size" do
    item = DummyContentItem.new(%w(1 2 3), %w(foo bar baz))

    assert_equal %w(foo bar baz), item.choose
  end
end
