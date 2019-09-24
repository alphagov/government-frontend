require "test_helper"

class FeatureTogglerTest < ActiveSupport::TestCase
  test "use_recommended_related_links returns false when content item has no links attribute" do
    content_item = {}
    instance = setup_feature_toggler_with_feature_enabled(true)

    use_recommended_links = instance.use_recommended_related_links?(content_item["links"], @request_headers)

    assert_equal(false, use_recommended_links)
  end

  test "use_recommended_related_links returns false when content item has existing ordered_related_items" do
    content_item = { "links" => { "ordered_related_items" => [{ "content_id" => "1234" }] } }
    instance = setup_feature_toggler_with_feature_enabled(true)

    use_recommended_links = instance.use_recommended_related_links?(content_item["links"], @request_headers)

    assert_equal(false, use_recommended_links)
  end

  test "use_recommended_related_links returns false when headers are not correct" do
    content_item = { "links" => {} }
    instance = setup_feature_toggler_with_feature_enabled(false)

    use_recommended_links = instance.use_recommended_related_links?(content_item["links"], {})

    assert_equal(false, use_recommended_links)
  end

  test "use_recommended_related_links returns true when content item has no ordered_related_items attribute and headers are correct" do
    content_item = { "links" => {} }
    instance = setup_feature_toggler_with_feature_enabled(true)

    use_recommended_links = instance.use_recommended_related_links?(content_item["links"], @request_headers)

    assert_equal(true, use_recommended_links)
  end

  test "use_recommended_related_links returns true when content item has no items in ordered_related_items attribute and headers are correct" do
    content_item = { "links" => { "ordered_related_items" => [] } }
    instance = setup_feature_toggler_with_feature_enabled(true)

    use_recommended_links = instance.use_recommended_related_links?(content_item["links"], @request_headers)

    assert_equal(true, use_recommended_links)
  end

  test "feature_flags attr_reader delegates to instance of feature_flags" do
    feature_flags = HttpFeatureFlags.new
    feature_toggler = FeatureToggler.new(feature_flags)

    assert_equal feature_flags, feature_toggler.feature_flags
  end

  def setup
    @request_headers = { 'HTTP_GOVUK_USE_RECOMMENDED_RELATED_LINKS': "true" }
  end

  def setup_feature_toggler_with_feature_enabled(feature_enabled)
    feature_flags = HttpFeatureFlags.new
    feature_flags.stubs(:feature_enabled?).returns(feature_enabled)

    FeatureToggler.new(feature_flags)
  end
end
