require 'test_helper'

class ContentItemsControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::ContentStore
  include GovukAbTesting::MinitestHelpers

  test "shows the original page content on the control version of the self assessment guide" do
    content_item = content_store_has_schema_example('guide', 'guide')
    path = 'log-in-file-self-assessment-tax-return'
    content_item['base_path'] = "/#{path}"
    content_item['details'] = {
      parts: [
        body: "The original part one"
      ]
    }
    content_store_has_item(content_item['base_path'], content_item)

    setup_ab_variant("SelfAssessmentSigninTest", "A")

    get :show, params: { path: path_for(content_item) }
    assert @response.body.include?('The original part one')
  end

  test "overwrites content for the first page of the self assessment guide" do
    content_item = content_store_has_schema_example('guide', 'guide')
    path = 'log-in-file-self-assessment-tax-return'
    content_item['base_path'] = "/#{path}"

    content_store_has_item(content_item['base_path'], content_item)

    setup_ab_variant("SelfAssessmentSigninTest", "B")

    get :show, params: { path: path_for(content_item) }
    assert @response.body.include?('Sign in to continue')
  end

  test "other guide pages are not overwritten" do
    %w(A B).each do |variant|
      content_item = content_store_has_schema_example('guide', 'guide')
      path = 'guide-page'
      content_item['base_path'] = "/#{path}"
      content_item['details'] = {
        parts: [
          body: "The original part one"
        ]
      }

      content_store_has_item(content_item['base_path'], content_item)

      setup_ab_variant("SelfAssessmentSigninTest", variant)

      get :show, params: { path: path_for(content_item) }
      assert @response.body.include?('The original part one')
    end
  end

  def path_for(content_item, locale = nil)
    base_path = content_item['base_path'].sub(/^\//, '')
    base_path.gsub!(/\.#{locale}$/, '') if locale
    base_path
  end
end
