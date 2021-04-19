require "test_helper"

class WeightedLinksPageTest < ActiveSupport::TestCase
  test "is invalid without any attributes" do
    attrs = {}

    assert_raise do
      WeightedLinksPage.new(attrs)
    end
  end

  test "is invalid without any related links" do
    attrs = {
      "page_base_path" => "/coronavirus",
    }

    assert_raise do
      WeightedLinksPage.new(attrs)
    end
  end

  test "has errors if related links are not an array" do
    attrs = {
      "page_base_path" => "/coronavirus",
      "related_links" => "not an array",
    }

    assert_raise do
      page = WeightedLinksPage.new(attrs)
      assert_not_empty page.errors.messages
    end
  end

  test "valid" do
    attrs = {
      "page_base_path" => "/coronavirus",
      "related_links" => %w[stuff in here],
    }
    page = WeightedLinksPage.new(attrs)

    assert page.valid?
    assert_empty page.errors.messages
  end

  test "load" do
    attrs = {
      "page_base_path" => "/coronavirus",
      "related_links" => %w[/stay-at-home /wear-a-mask /wash-your-hands],
    }
    page = WeightedLinksPage.load(attrs)

    assert_equal "/coronavirus", page.page_base_path
    assert page.related_links.is_a?(Array)

    %w[/stay-at-home /wear-a-mask /wash-your-hands].each do |related_link|
      assert page.related_links.include?(related_link)
    end
  end

  test "find_page_with_base_path" do
    attrs = {
      "page_base_path" => "/brexit",
      "related_links" => %w[/travelling-abroad /customs /citizenship],
    }
    page = WeightedLinksPage.load(attrs)

    WeightedLinksPage.expects(:find_page_with_base_path).with("/brexit").returns(page)
    assert_equal page, WeightedLinksPage.find_page_with_base_path("/brexit")
  end
end
