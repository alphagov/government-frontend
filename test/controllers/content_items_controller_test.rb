require "test_helper"

class ContentItemsControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::ContentStore
  include GovukAbTesting::MinitestHelpers

  test "routing handles paths with no format or locale" do
    assert_routing(
      "/government/news/statement-the-status-of-eu-nationals-in-the-uk",
      controller: "content_items",
      action: "show",
      path: "government/news/statement-the-status-of-eu-nationals-in-the-uk",
    )
  end

  test "routing handles paths for all supported locales" do
    I18n.available_locales.each do |locale|
      assert_routing(
        "/government/news/statement-the-status-of-eu-nationals-in-the-uk.#{locale}",
        controller: "content_items",
        action: "show",
        path: "government/news/statement-the-status-of-eu-nationals-in-the-uk",
        locale: locale.to_s,
      )
    end
  end

  test "routing handles paths with just format" do
    assert_routing(
      "/government/news/statement-the-status-of-eu-nationals-in-the-uk.atom",
      controller: "content_items",
      action: "show",
      path: "government/news/statement-the-status-of-eu-nationals-in-the-uk",
      format: "atom",
    )
  end

  test "routing handles paths with format and locale" do
    assert_routing(
      "/government/news/statement-the-status-of-eu-nationals-in-the-uk.es.atom",
      controller: "content_items",
      action: "show",
      path: "government/news/statement-the-status-of-eu-nationals-in-the-uk",
      format: "atom",
      locale: "es",
    )
  end

  test "routing handles paths with print variant" do
    assert_routing(
      "/government/news/statement-the-status-of-eu-nationals-in-the-uk/print",
      controller: "content_items",
      action: "show",
      path: "government/news/statement-the-status-of-eu-nationals-in-the-uk",
      variant: "print",
    )
  end

  test "redirects route with invalid parts to base path" do
    content_item = content_store_has_schema_example("travel_advice", "full-country")
    invalid_part_path = "#{path_for(content_item)}/not-a-valid-part"

    # The content store performs a 301 to the base path when requesting a content item
    # with any part URL. Simulate this by stubbing a request that returns the content
    # item.
    stub_request(:get, %r{#{invalid_part_path}})
      .to_return(status: 200, body: content_item.to_json, headers: {})

    get :show, params: { path: invalid_part_path }

    assert_response :redirect
    assert_redirected_to content_item["base_path"]
  end

  test "redirects route for first path to base path" do
    content_item = content_store_has_schema_example("guide", "guide")
    invalid_part_path = "#{path_for(content_item)}/#{content_item['details']['parts'].first['slug']}"

    stub_request(:get, %r{#{invalid_part_path}}).to_return(status: 200, body: content_item.to_json, headers: {})

    @controller.stubs(:page_in_scope?).returns(false)

    get :show, params: { path: invalid_part_path }

    assert_response :redirect
    assert_redirected_to content_item["base_path"]
  end

  test "returns HTML when an unspecific accepts header is requested (eg by IE8 and below)" do
    request.headers["Accept"] = "*/*"
    content_item = content_store_has_schema_example("travel_advice", "full-country")

    get :show,
        params: {
          path: path_for(content_item),
        }

    assert_match(/text\/html/, response.headers["Content-Type"])
    assert_response :success
    assert_select "#wrapper"
  end

  test "returns a 406 for XMLHttpRequests without an Accept header set to a supported format" do
    request.headers["X-Requested-With"] = "XMLHttpRequest"
    content_item = content_store_has_schema_example("case_study", "case_study")

    get :show,
        params: {
          path: path_for(content_item),
        }

    assert_response :not_acceptable
  end

  test "returns a 406 for unsupported format requests, eg text/javascript" do
    request.headers["Accept"] = "text/javascript"
    content_item = content_store_has_schema_example("case_study", "case_study")

    get :show,
        params: {
          path: path_for(content_item),
        }

    assert_response :not_acceptable
  end

  test "gets item from content store" do
    content_item = content_store_has_schema_example("case_study", "case_study")

    get :show, params: { path: path_for(content_item) }
    assert_response :success
    assert_equal content_item["title"], assigns[:content_item].title
  end

  test "gets item from content store and keeps existing ordered_related_items when feature flag header not specified" do
    HttpFeatureFlags.instance.add_http_feature_flag(FeatureFlagNames.recommended_related_links, "true")
    content_item = content_store_has_schema_example("case_study", "case_study")

    get :show, params: { path: path_for(content_item) }
    assert_response :success
    assert_equal content_item["links"]["ordered_related_items"], assigns[:content_item].content_item["links"]["ordered_related_items"]
  end

  test "gets item from content store and keep existing ordered_related_items when feature flag header is specified but links already exist" do
    HttpFeatureFlags.instance.add_http_feature_flag(FeatureFlagNames.recommended_related_links, "true")
    request.headers["HTTP_GOVUK_USE_RECOMMENDED_RELATED_LINKS"] = "true"

    content_item = content_store_has_schema_example("guide", "guide")

    get :show, params: { path: path_for(content_item) }
    assert_response :success
    assert_not_empty content_item["links"]["ordered_related_items"], "Content item should have existing related links"
    assert_not_empty content_item["links"]["suggested_ordered_related_items"], "Content item should have existing suggested related links"
    assert_equal content_item["links"]["ordered_related_items"], assigns[:content_item].content_item["links"]["ordered_related_items"]
  end

  test "gets item from content store and does not change ordered_related_items when feature flag header is specified but link overrides exist" do
    HttpFeatureFlags.instance.add_http_feature_flag(FeatureFlagNames.recommended_related_links, "true")
    request.headers["HTTP_GOVUK_USE_RECOMMENDED_RELATED_LINKS"] = "true"

    content_item = content_store_has_schema_example("guide", "guide-with-related-link-overrides")

    get :show, params: { path: path_for(content_item) }
    assert_response :success
    assert_nil content_item["links"]["ordered_related_items"], "Content item should not have existing related links"
    assert_not_empty content_item["links"]["ordered_related_items_overrides"], "Content item should have existing related link overrides"
    assert_not_empty content_item["links"]["suggested_ordered_related_items"], "Content item should have existing suggested related links"
    assert_nil content_item["links"]["ordered_related_items"]
  end

  test "gets item from content store and keeps ordered_related_items when feature flag header is specified but recommended links turned off" do
    HttpFeatureFlags.instance.add_http_feature_flag(FeatureFlagNames.recommended_related_links, "false")
    request.headers["HTTP_GOVUK_USE_RECOMMENDED_RELATED_LINKS"] = "true"

    content_item = content_store_has_schema_example("case_study", "case_study")

    get :show, params: { path: path_for(content_item) }
    assert_response :success
    assert_empty content_item["links"]["ordered_related_items"], "Content item should have existing related links"
    assert_not_empty content_item["links"]["suggested_ordered_related_items"], "Content item should have existing suggested related links"
    assert_equal [], assigns[:content_item].content_item["links"]["ordered_related_items"]
  end

  test "gets item from content store and replaces ordered_related_items when feature flag header is specified and there are no existing links or overrides" do
    HttpFeatureFlags.instance.add_http_feature_flag(FeatureFlagNames.recommended_related_links, "true")
    request.headers["HTTP_GOVUK_USE_RECOMMENDED_RELATED_LINKS"] = "true"

    content_item = content_store_has_schema_example("case_study", "case_study")

    get :show, params: { path: path_for(content_item) }
    assert_response :success
    assert_empty content_item["links"]["ordered_related_items"], "Content item should not have existing related links"
    assert_not_empty content_item["links"]["suggested_ordered_related_items"], "Content item should have existing suggested related links"
    assert_equal assigns[:content_item].content_item["links"]["ordered_related_items"], content_item["links"]["suggested_ordered_related_items"]
  end

  test "sets the Govuk-Use-Recommended-Links response header to false when request header is not set" do
    HttpFeatureFlags.instance.add_http_feature_flag(FeatureFlagNames.recommended_related_links, "true")
    content_item = content_store_has_schema_example("case_study", "case_study")

    get :show, params: { path: path_for(content_item) }

    assert_includes response.headers["Vary"], FeatureFlagNames.recommended_related_links
    assert_equal "false", response.headers[FeatureFlagNames.recommended_related_links]
  end

  test "sets the Govuk-Use-Recommended-Links response header to false when request header is set to false" do
    HttpFeatureFlags.instance.add_http_feature_flag(FeatureFlagNames.recommended_related_links, "true")
    request.headers["HTTP_GOVUK_USE_RECOMMENDED_RELATED_LINKS"] = "false"
    content_item = content_store_has_schema_example("case_study", "case_study")

    get :show, params: { path: path_for(content_item) }

    assert_includes response.headers["Vary"], FeatureFlagNames.recommended_related_links
    assert_equal "false", response.headers[FeatureFlagNames.recommended_related_links]
  end

  test "sets the Govuk-Use-Recommended-Links response header to true when request header is set to true" do
    HttpFeatureFlags.instance.add_http_feature_flag(FeatureFlagNames.recommended_related_links, "true")
    request.headers["HTTP_GOVUK_USE_RECOMMENDED_RELATED_LINKS"] = "true"
    content_item = content_store_has_schema_example("case_study", "case_study")

    get :show, params: { path: path_for(content_item) }

    assert_includes response.headers["Vary"], FeatureFlagNames.recommended_related_links
    assert_equal "true", response.headers[FeatureFlagNames.recommended_related_links]
  end

  test "sets the expiry as sent by content-store" do
    content_item = content_store_has_schema_example("coming_soon", "coming_soon")
    stub_content_store_has_item(content_item["base_path"], content_item, max_age: 20)

    get :show, params: { path: path_for(content_item) }
    assert_response :success
    assert_equal "max-age=20, public", @response.headers["Cache-Control"]
  end

  test "sets a longer cache-control header for travel advice atom feeds" do
    content_item = content_store_has_schema_example("travel_advice", "full-country")
    get :show, params: { path: path_for(content_item), format: "atom" }

    assert_response :success
    assert_equal "max-age=300, public", @response.headers["Cache-Control"]
  end

  test "honours cache-control private items" do
    content_item = content_store_has_schema_example("coming_soon", "coming_soon")
    stub_content_store_has_item(content_item["base_path"], content_item, private: true)

    get :show, params: { path: path_for(content_item) }
    assert_response :success
    assert_equal "max-age=900, private", @response.headers["Cache-Control"]
  end

  test "renders translated content items in their locale" do
    content_item = content_store_has_schema_example("case_study", "translated")
    locale = content_item["locale"]
    translated_schema_name = I18n.t("content_item.schema_name.case_study", count: 1, locale: locale)

    get :show, params: { path: path_for(content_item, locale), locale: locale }

    assert_response :success
    assert_select "title", %r{#{translated_schema_name}}
  end

  test "renders atom feeds" do
    content_item = content_store_has_schema_example("travel_advice", "full-country")
    get :show, params: { path: path_for(content_item), format: "atom" }

    assert_response :success
    assert_select "feed title", "Travel Advice Summary"
  end

  test "renders print variants" do
    content_item = content_store_has_schema_example("travel_advice", "full-country")
    get :show, params: { path: path_for(content_item), variant: "print" }

    assert_response :success
    assert_equal request.variant, [:print]
    assert_select "#travel-advice-print"
  end

  test "gets item from content store even when url contains multi-byte UTF8 character" do
    content_item = content_store_has_schema_example("case_study", "case_study")
    utf8_path    = "government/case-studies/caf\u00e9-culture"
    content_item["base_path"] = "/#{utf8_path}"

    stub_content_store_has_item(content_item["base_path"], content_item)

    get :show, params: { path: utf8_path }
    assert_response :success
  end

  test "returns 404 for invalid url" do
    path = "foreign-travel-advice/egypt]"

    stub_content_store_does_not_have_item("/" + path)

    get :show, params: { path: path }
    assert_response :not_found
  end

  test "returns 404 for item not in content store" do
    path = "government/case-studies/boost-chocolate-production"

    stub_content_store_does_not_have_item("/" + path)

    get :show, params: { path: path }
    assert_response :not_found
  end

  test "returns 404 if content store falls through to special route" do
    path = "government/item-not-here"

    content_item = content_store_has_schema_example("special_route", "special_route")
    content_item["base_path"] = "/government"

    stub_content_store_has_item("/#{path}", content_item)

    get :show, params: { path: path }
    assert_response :not_found
  end

  test "returns 403 for access-limited item" do
    path = "government/case-studies/super-sekrit-document"
    url = content_store_endpoint + "/content/" + path
    stub_request(:get, url).to_return(status: 403, headers: {})

    get :show, params: { path: path }
    assert_response :forbidden
  end

  test "returns 406 for schema types which don't support provided format" do
    content_item_without_atom = content_store_has_schema_example("case_study", "case_study")
    get :show, params: { path: path_for(content_item_without_atom), format: "atom" }

    assert_response :not_acceptable
  end

  test "returns 410 for content items that are gone" do
    stub_content_store_has_gone_item("/gone-item")
    get :show, params: { path: "gone-item" }
    assert_response :gone
  end

  test "returns a redirect when content item is a redirect" do
    content_item = content_store_has_schema_example("redirect", "redirect")
    stub_content_store_has_item("/406beacon", content_item)

    get :show, params: { path: "406beacon" }
    assert_redirected_to "https://www.test.gov.uk/maritime-safety-weather-and-navigation/register-406-mhz-beacons?query=answer#fragment"
  end

  test "returns a prefixed redirect when content item is a prefix redirect" do
    content_item = content_store_has_schema_example("redirect", "redirect")
    stub_content_store_has_item("/406beacon/prefix/to-preserve", content_item)

    get :show, params: { path: "406beacon/prefix/to-preserve" }
    assert_redirected_to "https://www.test.gov.uk/new-406-beacons-destination/to-preserve"
  end

  test "sets the Access-Control-Allow-Origin header for atom pages" do
    content_store_has_schema_example("travel_advice", "full-country")
    get :show, params: { path: "foreign-travel-advice/albania", format: "atom" }

    assert_equal response.headers["Access-Control-Allow-Origin"], "*"
  end

  test "renders briefing view correctly" do
    content_item = content_store_has_schema_example("news_article", "news_article")
    content_item["content_id"] = "3d66e959-72d2-417d-89c1-00cd72eea30f"
    stub_content_store_has_item(content_item["base_path"], content_item)

    get :show, params: { path: path_for(content_item) }
    assert_response :success
    assert_select ".gem-c-title", content_item["title"]
    assert_select ".gem-c-lead-paragraph", content_item["description"]
    assert_select ".gem-c-govspeak"
    assert_select ".gem-c-share-links"
    assert_select ".gem-c-title .gem-c-title__context", false
    assert_select ".metadata-logo-wrapper", false
    assert_select ".app-c-figure", false
    assert_select ".gem-c-contextual-sidebar", false
    assert_select ".app-c-published-dates", false
    assert_select ".gem-c-contextual-footer", false
  end

  %w[A B].each do |test_variant|
    test "record cookieless hit when in variant #{test_variant}" do
      with_variant CookielessAATest: test_variant.to_s do
        content_item = content_store_has_schema_example("case_study", "case_study")

        get :show, params: { path: path_for(content_item) }
        assert_select "meta[data-module=track-variant][content=#{test_variant}]"
      end
    end
  end

  test "not record cookieless hit when in variant Z" do
    with_variant CookielessAATest: "Z" do
      content_item = content_store_has_schema_example("case_study", "case_study")

      get :show, params: { path: path_for(content_item) }
      assert_select "meta[data-module=track-variant]", false
    end
  end

  def path_for(content_item, locale = nil)
    base_path = content_item["base_path"].sub(/^\//, "")
    base_path.gsub!(/\.#{locale}$/, "") if locale
    base_path
  end
end
