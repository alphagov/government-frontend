require 'test_helper'

class ContentItemsControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::ContentStore

  test "routing handles translated content paths" do
    translated_path = 'government/case-studies/allez.fr'

    assert_routing({ path: translated_path, method: :get },
      { controller: 'content_items', action: 'show', path: translated_path })
  end

  test "gets item from content store" do
    content_item = govuk_content_schema_example('case_study')

    get :show, path: path_for(content_item)
    assert_response :success
    assert_equal content_item['title'], assigns[:content_item].title
  end

  test "renders translated content items in their locale" do
    content_item = govuk_content_schema_example('translated')
    translated_format_name = I18n.t("content_item.format.case_study", count: 10, locale: 'es')

    get :show, path: path_for(content_item)

    assert_response :success
    assert_select "title", %r(#{translated_format_name})
  end

  test "gets item from content store even when url contains multi-byte UTF8 character" do
    content_item = govuk_content_schema_example('case_study')
    utf8_path    = "government/case-studies/caf\u00e9-culture"
    content_item['base_path'] = "/#{utf8_path}"

    content_store_has_item(content_item['base_path'], content_item)

    get :show, path: utf8_path
    assert_response :success
  end

  test "returns 404 for item not in content store" do
    path = 'government/case-studies/boost-chocolate-production'

    content_store_does_not_have_item('/' + path)

    get :show, path: path
    assert_response :not_found
  end

private

  def path_for(content_item)
    content_item['base_path'].sub(/^\//, '')
  end
end
