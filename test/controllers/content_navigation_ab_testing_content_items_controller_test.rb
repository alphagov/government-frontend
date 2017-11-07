require 'test_helper'

class ContentItemsControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::ContentStore
  include GovukAbTesting::MinitestHelpers

  ContentItemsController::GUIDANCE_DOCUMENT_TYPES.each do |document_type|
    schema_name = document_type == 'statutory_guidance' ? 'publication' : document_type

    test "does not show universal navigation when no taxons are tagged to #{document_type}" do
      content_item = content_store_has_schema_example(schema_name, schema_name)
      path = "government/abtest/#{schema_name}"
      content_item['base_path'] = "/#{path}"
      content_item['links'] = {}

      content_store_has_item(content_item['base_path'], content_item)

      setup_ab_variant('ContentNavigation', ContentItemsController::CONTENT_NAVIGATION_ORIGINAL)
      get :show, params: { path: path }
      assert_equal [], @request.variant
      assert_response_not_modified_for_ab_test('ContentNavigation')
    end

    test "#{document_type} honours content navigation AB Testing cookie" do
      content_item = content_store_has_schema_example(schema_name, schema_name)
      path = "government/abtest/#{schema_name}"
      content_item['document_type'] = document_type
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

      ContentItemsController::CONTENT_NAVIGATION_ALLOWED_VARIANTS.each do |variant|
        with_variant ContentNavigation: variant do
          get :show, params: { path: path }
          requested = @controller.content_navigation_ab_test.requested_variant(request.headers)
          assert_response 200
          assert requested.variant?(variant)

          if variant == ContentItemsController::CONTENT_NAVIGATION_ORIGINAL
            assert_equal [:taxonomy_navigation], @request.variant
          else
            assert_equal [:universal_navigation], @request.variant
          end
        end
      end
    end

    test "defaults to original view without AB testing cookie for #{document_type}" do
      content_item = content_store_has_schema_example(schema_name, schema_name)
      path = "government/abtest/#{schema_name}"
      content_item['document_type'] = document_type
      content_item['base_path'] = "/#{path}"
      content_item['links'] = {}
      content_store_has_item(content_item['base_path'], content_item)

      get :show, params: { path: path }
      assert_response 200
      assert_equal [], @request.variant
    end
  end
end
