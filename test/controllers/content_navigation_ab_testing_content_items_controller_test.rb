require 'test_helper'

class ContentItemsControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::ContentStore
  include GovukAbTesting::MinitestHelpers

  ContentItemsController::GUIDANCE_DOCUMENT_TYPES.each do |document_type|
    schema_name = document_type == 'statutory_guidance' ? 'publication' : document_type

    test "does not show universal navigation when no taxons are tagged to #{document_type}" do
      path = "government/abtest/#{schema_name}"
      content_item_outside_of_test(document_type, schema_name, path)

      setup_ab_variant('ContentNavigation', ContentItemsController::CONTENT_NAVIGATION_ORIGINAL)
      get :show, params: { path: path }
      assert_equal [], @request.variant
      assert_response_not_modified_for_ab_test('ContentNavigation')
    end

    test "#{document_type} honours content navigation AB Testing cookie" do
      path = "government/abtest/#{schema_name}"
      content_item_inside_of_test(document_type, schema_name, path)

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
      path = "government/abtest/#{schema_name}"
      content_item_inside_of_test(document_type, schema_name, path)

      get :show, params: { path: path }
      requested_variant_name = @controller.content_navigation_ab_test.requested_variant(request.headers).variant_name
      assert_response 200
      assert_equal [:taxonomy_navigation], @request.variant
      assert_equal ContentItemsController::CONTENT_NAVIGATION_ORIGINAL, requested_variant_name
    end

    test "#{document_type} does not mark itself as in variant when ab test does not apply" do
      path = "government/abtest/#{schema_name}"
      content_item_outside_of_test(document_type, schema_name, path)

      ContentItemsController::CONTENT_NAVIGATION_ALLOWED_VARIANTS.each do |variant|
        request.headers["GOVUK-ABTest-#{ContentItemsController::CONTENT_NAVIGATION_TEST_NAME}"] = variant
        get :show, params: { path: path }
        assert_response 200
        refute @controller.content_navigation_ab_test_applies?

        refute @controller.universal_navigation_without_nav?
        refute @controller.universal_navigation_with_taxon_nav?
        refute @controller.universal_navigation_with_mainstream_nav?
      end
    end
  end

  def content_item_inside_of_test(document_type, schema_name, path)
    content_item = content_item_document_type_example(document_type, schema_name, path)
    content_item['links'] = {
      'taxons' => [
        {
          'title' => 'A Taxon',
          'base_path' => '/a-taxon',
        }
      ]
    }
    content_store_has_item(content_item['base_path'], content_item)
  end

  def content_item_outside_of_test(document_type, schema_name, path)
    content_item = content_item_document_type_example(document_type, schema_name, path)
    content_item['links'] = {}
    content_store_has_item(content_item['base_path'], content_item)
  end

  def content_item_document_type_example(document_type, schema_name, path)
    content_item = content_store_has_schema_example(schema_name, schema_name)
    content_item['document_type'] = document_type
    content_item['base_path'] = "/#{path}"
    content_item
  end
end
