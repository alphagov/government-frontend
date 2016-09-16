require 'test_helper'

class BreadcrumbsTest < ActionView::TestCase
  test "returns empty breadcrumbs when parent is not specified" do
    content_item = build_content_item
    assert_equal [], content_item.breadcrumbs
  end

  test "returns empty breadcrumbs when parent is empty" do
    links = { parent: [] }
    content_item = build_content_item(links)
    assert_equal [], content_item.breadcrumbs
  end

  test "returns breadcrumbs when there is a parent" do
    links = {
      "parent" => [
        { "title" => "A-parent", "base_path" => "/a-parent" }
      ]
    }

    content_item = build_content_item(links)

    assert_equal [
      { title: "Home", url: "/" },
      { title: "A-parent", url: "/a-parent" },
    ], content_item.breadcrumbs
  end

  test "returns breadcrumbs when there is more than one parent" do
    links = {
      "parent" => [
        {
          "title" => "A-parent",
          "base_path" => "/a-parent",
          "links" => {
            "parent" => [{
              "title" => "Another-parent",
              "base_path" => "/another-parent",
            }]
          }
        }
      ]
    }

    content_item = build_content_item(links)

    assert_equal [
      { title: "Home", url: "/" },
      { title: "Another-parent", url: "/another-parent" },
      { title: "A-parent", url: "/a-parent" },
    ], content_item.breadcrumbs
  end

private

  def build_content_item(links = [])
    ItemWithBreadrumbs.new(
      "title" => "a title",
      "description" => "a description",
      "format" => "a format",
      "phase" => "live",
      "document_type" => "content_item",
      "links" => links,
    )
  end
end

class ItemWithBreadrumbs < ContentItemPresenter
  include Breadcrumbs
end
