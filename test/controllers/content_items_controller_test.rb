require 'test_helper'

class ContentItemsControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::ContentStore
  include GovukAbTesting::MinitestHelpers

  test 'routing handles paths with no format or locale' do
    assert_routing(
      '/government/news/statement-the-status-of-eu-nationals-in-the-uk',
      controller: 'content_items',
      action: 'show',
      path: 'government/news/statement-the-status-of-eu-nationals-in-the-uk',
    )
  end

  test 'routing handles paths for all supported locales' do
    I18n.available_locales.each do |locale|
      assert_routing(
        "/government/news/statement-the-status-of-eu-nationals-in-the-uk.#{locale}",
        controller: 'content_items',
        action: 'show',
        path: 'government/news/statement-the-status-of-eu-nationals-in-the-uk',
        locale: locale.to_s
      )
    end
  end

  test 'routing handles paths with just format' do
    assert_routing(
      '/government/news/statement-the-status-of-eu-nationals-in-the-uk.atom',
      controller: 'content_items',
      action: 'show',
      path: 'government/news/statement-the-status-of-eu-nationals-in-the-uk',
      format: 'atom',
    )
  end

  test 'routing handles paths with format and locale' do
    assert_routing(
      '/government/news/statement-the-status-of-eu-nationals-in-the-uk.es.atom',
      controller: 'content_items',
      action: 'show',
      path: 'government/news/statement-the-status-of-eu-nationals-in-the-uk',
      format: 'atom',
      locale: 'es'
    )
  end

  test 'routing handles paths with print variant' do
    assert_routing(
      '/government/news/statement-the-status-of-eu-nationals-in-the-uk/print',
      controller: 'content_items',
      action: 'show',
      path: 'government/news/statement-the-status-of-eu-nationals-in-the-uk',
      variant: 'print'
    )
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
    locale = content_item['locale']
    translated_format_name = I18n.t("content_item.format.case_study", count: 1, locale: locale)

    get :show, params: { path: path_for(content_item, locale), locale: locale }

    assert_response :success
    assert_select "title", %r(#{translated_format_name})
  end

  test "renders atom feeds" do
    content_item = content_store_has_schema_example('travel_advice', 'full-country')
    get :show, params: { path: path_for(content_item), format: 'atom' }

    assert_response :success
    assert_select "feed title", 'Travel Advice Summary'
  end

  test "renders print variants" do
    content_item = content_store_has_schema_example('travel_advice', 'full-country')
    get :show, params: { path: path_for(content_item), variant: 'print' }

    assert_response :success
    assert_equal request.variant, [:print]
    assert_select ".travel-advice-print"
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

  test "returns 406 for schema types which don't support provided format" do
    content_item_without_atom = content_store_has_schema_example('case_study', 'case_study')
    get :show, params: { path: path_for(content_item_without_atom), format: 'atom' }

    assert_response :not_acceptable
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

  def path_for(content_item, locale = nil)
    base_path = content_item['base_path'].sub(/^\//, '')
    base_path.gsub!(/\.#{locale}$/, '') if locale
    base_path
  end

  def taxonomy_sidebar
    Nokogiri::HTML.parse(response.body).at_css(".column-third")
  end
end
