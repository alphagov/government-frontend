require 'test_helper'

class ContentItemsControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::ContentStore
  include GovukAbTesting::MinitestHelpers

  %w(A B).each do |test_variant|
    test "ContentPagesNav variant #{test_variant} works with a valid taxon" do
      content_item = content_store_has_schema_example("guide", "single-page-guide").tap do |item|
        item["links"]["taxons"] = SINGLE_TAXON
      end

      ensure_ab_test_is_correctly_setup(test_variant, content_item)
    end

    test "ContentPagesNav variant #{test_variant} works without a valid taxon" do
      content_item = content_store_has_schema_example("guide", "single-page-guide")
      content_store_has_item(content_item['base_path'], content_item)

      @controller.stubs(:page_in_scope?).returns(true)
      ensure_ab_test_is_correctly_setup(test_variant, content_item)
    end

    # HTML publications don't use the universal layout so we'll exclude them for now
    test "ContentPagesNav test is inactive for HTML publications (variant #{test_variant})" do
      content_item = content_store_has_schema_example("html_publication", "published").tap do |item|
        item["links"]["taxons"] = SINGLE_TAXON
      end

      setup_ab_variant("ContentPagesNav", test_variant)

      get :show, params: { path: path_for(content_item) }

      assert_response_not_modified_for_ab_test("ContentPagesNav")
    end

    test "ContentPagesNav test is inactive when content is not tagged to a live taxon (variant #{test_variant})" do
      content_item = content_store_has_schema_example("guide", "single-page-guide").tap do |item|
        item["links"]["taxons"] = SINGLE_NON_LIVE_TAXON
      end

      setup_ab_variant("ContentPagesNav", test_variant)

      get :show, params: { path: path_for(content_item) }

      assert_response_not_modified_for_ab_test("ContentPagesNav")
    end
  end

  def ensure_ab_test_is_correctly_setup(test_variant, content_item)
    content_store_has_item(content_item['base_path'], content_item)

    @controller.stubs(:page_in_scope?).returns(true)

      with_variant ContentPagesNav: test_variant do
        get :show, params: { path: path_for(content_item) }
        assert_response 200

        ab_test = GovukAbTesting::AbTest.new("ContentPagesNav", dimension: 65)
        requested = ab_test.requested_variant(request.headers)
        assert requested.variant?(test_variant)
      end
    end
  end

  def path_for(content_item, locale = nil)
    base_path = content_item['base_path'].sub(/^\//, '')
    base_path.gsub!(/\.#{locale}$/, '') if locale
    base_path
  end
end
