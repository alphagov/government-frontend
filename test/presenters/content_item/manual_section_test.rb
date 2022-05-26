require "test_helper"

class ContentItemManualSectionTest < ActiveSupport::TestCase
  class DummyContentItem
    attr_reader :manual_page_title, :content_item, :manual, :base_path
    attr_accessor :details

    include ContentItem::ManualSection
    def initialize
      @content_item = {}
      @content_item["title"] = "manualsectiontest"
      @manual_page_title = @content_item["title"]
      @details = { "section_id" => "ADML1000" }
      @manual = { "title" => "harrypotter" }
      @base_path = "/a/base/path"
    end
  end

  test "returns title" do
    item = DummyContentItem.new

    assert_equal("harrypotter", item.title)
  end

  test "returns page title" do
    item = DummyContentItem.new

    assert_equal("ADML1000 - manualsectiontest", item.page_title)
  end

  test "returns document_heading" do
    item = DummyContentItem.new

    assert_equal(%w[ADML1000 manualsectiontest], item.document_heading)
  end

  test "returns breadcrumb when section_id is present" do
    item = DummyContentItem.new

    assert_equal("ADML1000", item.breadcrumb)
  end

  test "returns breadcrumb when section_id not present" do
    item = DummyContentItem.new

    item.details = {}

    assert_equal("harrypotter", item.breadcrumb)
  end

  test "returns manual_content_item" do
    stub_request(:get, "https://content-store.test.gov.uk/content/a/base/path")
      .to_return(status: 200, body: "{}", headers: {})

    item = DummyContentItem.new

    assert_equal({}, item.manual_content_item.parsed_content)
  end
end
