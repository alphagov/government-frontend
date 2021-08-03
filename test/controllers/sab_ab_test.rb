require "test_helper"

class ContentItemsControllerTest < ActionController::TestCase
  include GovukAbTesting::MinitestHelpers
  INTERVENTION_CSS_SELECTOR = "gem-c-intervention".freeze

  test "shows intervention for variant B" do
    for_each_schema do |schema|
      with_variant StartABusinessSegment: "B" do
        with_is_sab_page_header("true") do
          set_up_and_visit_content_item_for_schema(schema)
          assert has_intervention_css_selector
        end
      end
    end
  end

  test "doesn't show intervention for variant A" do
    for_each_schema do |schema|
      with_variant StartABusinessSegment: "A" do
        with_is_sab_page_header("true") do
          set_up_and_visit_content_item_for_schema(schema)

          assert_not has_intervention_css_selector
        end
      end
    end
  end

  test "doesn't show intervention for variant C" do
    for_each_schema do |schema|
      with_variant StartABusinessSegment: "C" do
        with_is_sab_page_header("true") do
          set_up_and_visit_content_item_for_schema(schema)

          assert_not has_intervention_css_selector
        end
      end
    end
  end

private

  def set_up_and_visit_content_item_for_schema(schema)
    content_item = content_store_has_schema_example(schema, schema)
    stub_content_store_has_item(content_item["base_path"], content_item)
    path = content_item["base_path"][1..]

    get :show, params: { path: path }
  end

  def has_intervention_css_selector
    response.body.include?(INTERVENTION_CSS_SELECTOR)
  end

  def with_is_sab_page_header(is_sab_header)
    request.headers["HTTP_GOVUK_ABTEST_ISSTARTABUSINESSPAGE"] = is_sab_header
    yield
  end

  def for_each_schema(&block)
    %w[guide answer document_collection].each(&block)
  end
end
