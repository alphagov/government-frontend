require "test_helper"

class ContentItemManualTest < ActiveSupport::TestCase
  class DummyContentItem
    include ContentItem::Manual
    attr_reader :content_item, :view_context, :base_path, :public_updated_at, :title, :schema_name

    def initialize(schema_name = "manual")
      @view_context = ApplicationController.new.view_context
      @content_item = {
        "title" => "Super title",
        "base_path" => "/a/base/path",
        "public_updated_at" => "2022-03-23T08:30:20.000+00:00",
        "schema_name" => schema_name,
        "details" => {
          "body" => "body",
          "child_section_groups" => [{ "title" => "thing" }],
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

  test "returns page title for manual" do
    item = DummyContentItem.new

    assert_equal "#{item.title} - Guidance", item.page_title
  end

  test "returns page title for HMRC manual" do
    item = DummyContentItem.new("hmrc_manual")

    assert_equal "#{item.title} - HMRC internal manual", item.page_title
  end

  test "returns breadcrumbs" do
    item = DummyContentItem.new

    assert_equal [{ title: I18n.t("manuals.breadcrumb_contents") }], item.breadcrumbs
  end

  test "returns section groups" do
    item = DummyContentItem.new

    assert_equal [{ "title" => "thing" }], item.section_groups
  end

  test "returns body" do
    item = DummyContentItem.new

    assert_equal "body", item.body
  end

  test "returns extra publisher metadata" do
    item = DummyContentItem.new
    item.stubs(:display_date).returns("23 March 2022")

    expected_metadata = {
      from: ["<a class=\"govuk-link\" href=\"/blah\">blah</a>"],
      first_published: "23 March 2022",
      inverse: true,
      other: {
        I18n.t("manuals.updated") => "23 March 2022, <a href=\"/a/base/path/updates\">#{I18n.t('manuals.see_all_updates')}</a>",
      },
    }
    assert_equal expected_metadata, item.manual_metadata
  end
end
