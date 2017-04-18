require 'test_helper'

class TravelAdviceControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::ContentStore

  test "routing handles travel advice part paths" do
    path = 'foreign-travel-advice/thailand/money'

    assert_routing({ path: path, method: :get },
      controller: 'travel_advice', action: 'show', country: 'thailand', part: 'money')
  end

  test "gets same content item for part as base item" do
    content_item = content_store_has_schema_example('travel_advice', 'full-country')
    part_slug = content_item['details']['parts'][0]['slug']
    get :show, params: { country: 'albania', part: part_slug }

    assert_response :success
    assert_equal content_item['base_path'], assigns[:content_item].base_path
  end

  test "redirects invalid parts to travel advice base path" do
    content_item = content_store_has_schema_example('travel_advice', 'full-country')
    get :show, params: { country: 'albania', part: 'not-a-valid-part' }

    assert_response :redirect
    assert_redirected_to content_item['base_path']
  end

  test "passes the current part slug to the presenter" do
    content_item = content_store_has_schema_example('travel_advice', 'full-country')
    part_slug = content_item['details']['parts'][0]['slug']
    get :show, params: { country: 'albania', part: part_slug }

    assert_equal part_slug, assigns[:content_item].part_slug
  end

  # This is a duplicate test to one in content_items_controller_test.rb to
  # cover the additional route GET /foreign-travel-advice/:country/:part(.:format) travel_advice#show
  test "sets the Access-Control-Allow-Origin header to atom feed" do
    content_item = content_store_has_schema_example('travel_advice', 'full-country')
    part_slug = content_item['details']['parts'][0]['slug']
    get :show, params: { country: 'albania', part: part_slug, format: 'atom' }

    assert_equal response.headers["Access-Control-Allow-Origin"], "*"
  end
end
