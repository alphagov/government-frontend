require "test_helper"

class ContentItemNationalStatisticsLogoTest < ActiveSupport::TestCase
  class DummyContentItem
    include ContentItem::NationalStatisticsLogo
    attr_accessor :content_item

    def initialize
      @content_item = {
        "base_path" => "/a/base/path",
        "links" => {},
        "document_type" => "national_statistics",
      }
    end

    def national_statistics?
      content_item["document_type"] == "national_statistics"
    end
  end

  test "use English as default locale" do
    item = DummyContentItem.new

    correct_logo = {
      path: "accredited-official-statistics-en.png",
      alt_text: "Accredited official statistics",
    }
    assert_equal correct_logo, item.logo
  end

  test "detect Welsh locale" do
    item = DummyContentItem.new
    item.content_item["locale"] = "cy"

    correct_logo = {
      path: "accredited-official-statistics-cy.png",
      alt_text: "Ystadegau swyddogol achrededig",
    }
    I18n.with_locale(:cy) do
      assert_equal correct_logo, item.logo
    end
  end

  test "do not show logo for documents which are not national statistics" do
    item = DummyContentItem.new
    item.content_item["document_type"] = "other"

    assert_nil item.logo
  end
end
