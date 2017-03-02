require 'test_helper'

class ContentItemsControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::ContentStore
  include GovukAbTesting::MinitestHelpers

  setup do
    ENV['ENABLE_NEW_NAVIGATION'] = 'yes'
  end

  teardown do
    ENV['ENABLE_NEW_NAVIGATION'] = nil
  end

  test "routing handles translated content paths" do
    translated_path = 'government/case-studies/allez.fr'

    assert_routing({ path: translated_path, method: :get },
      controller: 'content_items', action: 'show', path: translated_path)
  end

  test "gets item from content store" do
    content_item = content_store_has_schema_example('case_study', 'case_study')

    get :show, params: { path: path_for(content_item) }
    assert_response :success
    assert_equal content_item['title'], assigns[:content_item].title
  end

  test "sets the expiry as sent by content-store" do
    content_item = content_store_has_schema_example('coming_soon', 'coming_soon')
    content_store_has_item(content_item['base_path'], content_item, max_age: 20)

    get :show, params: { path: path_for(content_item) }
    assert_response :success
    assert_equal "max-age=20, public", @response.headers['Cache-Control']
  end

  test "honours cache-control private items" do
    content_item = content_store_has_schema_example('coming_soon', 'coming_soon')
    content_store_has_item(content_item['base_path'], content_item, private: true)

    get :show, params: { path: path_for(content_item) }
    assert_response :success
    assert_equal "max-age=900, private", @response.headers['Cache-Control']
  end

  test "renders translated content items in their locale" do
    content_item = content_store_has_schema_example('case_study', 'translated')
    translated_format_name = I18n.t("content_item.format.case_study", count: 1, locale: 'es')

    get :show, params: { path: path_for(content_item) }

    assert_response :success
    assert_select "title", %r(#{translated_format_name})
  end

  test "gets item from content store even when url contains multi-byte UTF8 character" do
    content_item = content_store_has_schema_example('case_study', 'case_study')
    utf8_path    = "government/case-studies/caf\u00e9-culture"
    content_item['base_path'] = "/#{utf8_path}"

    content_store_has_item(content_item['base_path'], content_item)

    get :show, params: { path: utf8_path }
    assert_response :success
  end

  test "returns 404 for item not in content store" do
    path = 'government/case-studies/boost-chocolate-production'

    content_store_does_not_have_item('/' + path)

    get :show, params: { path: path }
    assert_response :not_found
  end

  test "returns 403 for access-limited item" do
    path = 'government/case-studies/super-sekrit-document'
    url = content_store_endpoint + "/content/" + path
    stub_request(:get, url).to_return(status: 403, headers: {})

    get :show, params: { path: path }
    assert_response :forbidden
  end

  test "defaults to 'A' view without AB Testing cookie for Detailed Guides" do
    content_item = content_store_has_schema_example('detailed_guide', 'detailed_guide')
    path = 'government/abtest/detailed-guide'
    content_item['base_path'] = "/#{path}"
    content_item['links'] = {
      'taxons' => [
        {
          'title' => 'A Taxon',
          'base_path' => '/a-taxon',
        }
      ]
    }

    content_store_has_item(content_item['base_path'], content_item)

    get :show, params: { path: path_for(content_item) }
    assert_equal [], @request.variant
    refute_match(/A Taxon/, taxonomy_sidebar)
  end

  test "honours Education Navigation AB Testing cookie for Detailed Guides" do
    content_item = content_store_has_schema_example('detailed_guide', 'detailed_guide')
    path = 'government/abtest/detailed-guide'
    content_item['base_path'] = "/#{path}"
    content_item['links'] = {
      'taxons' => [
        {
          'title' => 'A Taxon',
          'base_path' => '/a-taxon',
        }
      ]
    }

    content_store_has_item(content_item['base_path'], content_item)

    with_variant EducationNavigation: "A" do
      get :show, params: { path: path_for(content_item) }
      refute_match(/A Taxon/, taxonomy_sidebar)
    end

    with_variant EducationNavigation: "B" do
      get :show, params: { path: path_for(content_item) }
      assert_match(/A Taxon/, taxonomy_sidebar)
    end
  end

  test "does not show new navigation when no taxons are tagged to Detailed Guides" do
    content_item = content_store_has_schema_example('detailed_guide', 'detailed_guide')
    path = 'government/abtest/detailed-guide'
    content_item['base_path'] = "/#{path}"
    content_item['links'] = {}

    content_store_has_item(content_item['base_path'], content_item)

    setup_ab_variant('EducationNavigation', 'A')
    get :show, params: { path: path_for(content_item) }
    assert_equal [], @request.variant
    refute_match(/A Taxon/, taxonomy_sidebar)
    assert_response_not_modified_for_ab_test

    setup_ab_variant('EducationNavigation', 'B')
    get :show, params: { path: path_for(content_item) }
    assert_equal [], @request.variant
    refute_match(/A Taxon/, taxonomy_sidebar)
    assert_response_not_modified_for_ab_test
  end

  test "Case Studies are not included in the AB Test" do
    content_item = content_store_has_schema_example('case_study', 'case_study')
    path = 'government/abtest/case-study'
    content_item['base_path'] = "/#{path}"
    content_item['links'] = {
      'taxons' => [
        {
          'title' => 'A Taxon',
          'base_path' => '/a-taxon',
        }
      ]
    }

    content_store_has_item(content_item['base_path'], content_item)

    get :show, params: { path: path_for(content_item) }
    assert_equal [], @request.variant
    refute_match(/A Taxon/, taxonomy_sidebar)
    assert_response_not_modified_for_ab_test
  end

  test "document collections are tracked as 'finding' pages" do
    content_item = content_store_has_schema_example('document_collection', 'document_collection')

    get :show, params: { path: path_for(content_item) }

    assert_select "meta[name='govuk:user-journey-stage'][content='finding']", 1
  end

  test "content pages are tracked as the default user journey stage" do
    content_item = content_store_has_schema_example('case_study', 'case_study')

    get :show, params: { path: path_for(content_item) }

    # Assert that the meta tag is missing, which will be interpreted by the
    # analytics code as the default value
    assert_select "meta[name='govuk:user-journey-stage']", false
  end

  def path_for(content_item)
    content_item['base_path'].sub(/^\//, '')
  end

  def taxonomy_sidebar
    Nokogiri::HTML.parse(response.body).at_css(".column-third")
  end
end
