require 'gds_api/test_helpers/content_store'
require 'test_helper'

class ContentItemsControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::ContentStore

  test "routing handles translated content paths" do
    translated_path = 'government/case-studies/allez.fr'

    assert_routing({ path: translated_path, method: :get },
      { controller: 'content_items', action: 'show', path: translated_path })
  end

  test "gets item from content store" do
    path = 'government/case-studies/get-britain-building-carlisle-park'
    content_store_has_item('/' + path, read_content_store_fixture('case_study'))

    get :show, path: path
    assert_response :success
    assert_equal "Get Britain Building: Carlisle Park", assigns[:content_item]["title"]
  end

  test "returns 404 for item not in content store" do
    path = 'government/case-studies/boost-chocolate-production'

    content_store_does_not_have_item('/' + path)

    get :show, path: path
    assert_response :not_found
  end
end
