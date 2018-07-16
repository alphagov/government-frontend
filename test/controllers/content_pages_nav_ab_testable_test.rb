require 'test_helper'

class ContentItemsControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::ContentStore
  include GovukAbTesting::MinitestHelpers

  %w(A B).each do |test_variant|
    test "ContentPagesNav variant #{test_variant} works" do
      #this sample guide is not part of the education taxon
      content_item = content_store_has_schema_example("guide", "single-page-guide")
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
