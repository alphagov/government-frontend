require 'test_helper'

class ContentItemsControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::ContentStore
  include GovukAbTesting::MinitestHelpers

  %w(A B).each do |test_variant|
    test "GuideChapterNav variant #{test_variant} works for guides not in the education taxon" do
      #this sample guide is not part of the education taxon
      content_item = content_store_has_schema_example("guide", "single-page-guide")
      content_store_has_item(content_item['base_path'], content_item)

      with_variant GuideChapterNav: test_variant do
        get :show, params: { path: path_for(content_item) }
        assert_response 200

        ab_test = GovukAbTesting::AbTest.new("GuideChapterNav", dimension: 64)
        requested = ab_test.requested_variant(request.headers)
        assert requested.variant?(test_variant)
      end
    end

    test "GuideChapterNav variant #{test_variant} does not affect travel advice content" do
      content_item = content_store_has_schema_example("travel_advice", "full-country")
      content_store_has_item(content_item['base_path'], content_item)

      setup_ab_variant("GuideChapterNav", test_variant)

      get :show, params: { path: path_for(content_item) }
      assert_response 200
      assert_response_not_modified_for_ab_test("GuideChapterNav")
    end
  end

  test "GuideChapterNav shows the original nav on variant A" do
    # The example schema is in the education taxon which would remove it from
    # the test, so we'll stub it here
    @controller.stubs(:is_education?).returns(false)

    content_item = content_store_has_schema_example("guide", "guide")
    content_store_has_item(content_item['base_path'], content_item)

    with_variant GuideChapterNav: "A" do
      get :show, params: { path: path_for(content_item) }
      assert_response 200

      #original navigation section
      assert_match("part-navigation", response.body)

      #parts are still numbers
      assert_match("1. Overview", response.body)
    end
  end

  test "GuideChapterNav shows the alternate nav on variant B" do
    # The example schema is in the education taxon which would remove it from
    # the test, so we'll stub it here
    @controller.stubs(:is_education?).returns(false)

    content_item = content_store_has_schema_example("guide", "guide")
    content_store_has_item(content_item['base_path'], content_item)

    with_variant GuideChapterNav: "B" do
      get :show, params: { path: path_for(content_item) }
      assert_response 200

      #alternate navigation component
      assert_match("app-c-contents-list", response.body)

      #remove numbering from parts
      refute_match("1. Overview", response.body)
      assert_match("Overview", response.body)
    end
  end

  def path_for(content_item, locale = nil)
    base_path = content_item['base_path'].sub(/^\//, '')
    base_path.gsub!(/\.#{locale}$/, '') if locale
    base_path
  end
end
