require "test_helper"
require "gds_api/test_helpers/publishing_api"

class ContentItemsControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::ContentStore
  include GdsApi::TestHelpers::PublishingApi
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
    content_item = content_store_has_schema_example("guide", "guide")
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
    content_item = content_store_has_schema_example("guide", "guide")

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

  test "with the GraphQL feature flag enabled gets item from GraphQL if it is a news article" do
    Features.stubs(:graphql_feature_enabled?).returns(true)
    base_path = "content-item"

    graphql_fixture = fetch_graphql_fixture("news_article")
    stub_publishing_api_graphql_content_item(Graphql::EditionQuery.new("/#{base_path}").query, graphql_fixture)

    get :show,
        params: {
          path: base_path,
        }

    assert_requested :post, "#{PUBLISHING_API_ENDPOINT}/graphql",
                     body: { query: Graphql::EditionQuery.new("/#{base_path}").query },
                     times: 1

    assert_not_requested :get, "#{content_store_endpoint}/content/#{base_path}"

    assert_response :success
  end

  test "with the GraphQL feature flag enabled does not get item from GraphQL if it is not a news article" do
    Features.stubs(:graphql_feature_enabled?).returns(true)

    content_item = content_store_has_schema_example("case_study", "case_study")
    base_path = path_for(content_item)

    graphql_fixture = fetch_graphql_fixture("news_article")
    graphql_fixture["data"]["edition"]["schema_name"] = "case_study"
    stub_publishing_api_graphql_content_item(Graphql::EditionQuery.new("/#{base_path}").query, graphql_fixture)

    get :show,
        params: {
          path: path_for(content_item),
        }

    assert_requested :post, "#{PUBLISHING_API_ENDPOINT}/graphql",
                     body: { query: Graphql::EditionQuery.new("/#{base_path}").query }

    assert_requested :get, "#{content_store_endpoint}/content/#{base_path}",
                     times: 1

    assert_response :success
  end

  test "gets item from content store" do
    content_item = content_store_has_schema_example("case_study", "case_study")

    get :show, params: { path: path_for(content_item) }
    assert_response :success
    assert_equal content_item["title"], assigns[:content_item].title
  end

  test "sets prometheus labels on the rack env" do
    content_item = content_store_has_schema_example("case_study", "case_study")

    get :show, params: { path: path_for(content_item) }
    assert_response :success
    assert_equal @request.env["govuk.prometheus_labels"], { document_type: "case_study", schema_name: "case_study" }
  end

  test "gets item from content store and keeps existing ordered_related_items when links already exist" do
    content_item = content_store_has_schema_example("guide", "guide")

    get :show, params: { path: path_for(content_item) }
    assert_response :success
    assert_not_empty content_item["links"]["ordered_related_items"], "Content item should have existing related links"
    assert_not_empty content_item["links"]["suggested_ordered_related_items"], "Content item should have existing suggested related links"
    assert_equal content_item["links"]["ordered_related_items"], assigns[:content_item].content_item["links"]["ordered_related_items"]
  end

  test "gets item from content store and does not change ordered_related_items when link overrides exist" do
    content_item = content_store_has_schema_example("guide", "guide-with-related-link-overrides")

    get :show, params: { path: path_for(content_item) }
    assert_response :success
    assert_nil content_item["links"]["ordered_related_items"], "Content item should not have existing related links"
    assert_not_empty content_item["links"]["ordered_related_items_overrides"], "Content item should have existing related link overrides"
    assert_not_empty content_item["links"]["suggested_ordered_related_items"], "Content item should have existing suggested related links"
    assert_nil content_item["links"]["ordered_related_items"]
  end

  test "gets item from content store and replaces ordered_related_items there are no existing links or overrides" do
    content_item = content_store_has_schema_example("case_study", "case_study")

    get :show, params: { path: path_for(content_item) }
    assert_response :success
    assert_empty content_item["links"]["ordered_related_items"], "Content item should not have existing related links"
    assert_not_empty content_item["links"]["suggested_ordered_related_items"], "Content item should have existing suggested related links"
    assert_equal assigns[:content_item].content_item["links"]["ordered_related_items"], content_item["links"]["suggested_ordered_related_items"]
  end

  test "sets the expiry as sent by content-store" do
    content_item = content_store_has_schema_example("case_study", "case_study")
    stub_content_store_has_item(content_item["base_path"], content_item, max_age: 20)

    get :show, params: { path: path_for(content_item) }
    assert_response :success
    assert_equal "max-age=20, public", @response.headers["Cache-Control"]
  end

  test "honours cache-control private items" do
    content_item = content_store_has_schema_example("case_study", "case_study")
    stub_content_store_has_item(content_item["base_path"], content_item, private: true)

    get :show, params: { path: path_for(content_item) }
    assert_response :success
    assert_equal "max-age=900, private", @response.headers["Cache-Control"]
  end

  test "renders translated content items in their locale" do
    content_item = content_store_has_schema_example("case_study", "translated")
    locale = content_item["locale"]
    translated_schema_name = I18n.t("content_item.schema_name.case_study", count: 1, locale:)

    get :show, params: { path: path_for(content_item, locale), locale: }

    assert_response :success
    assert_select "title", %r{#{translated_schema_name}}
  end

  test "renders print variants" do
    content_item = content_store_has_schema_example("guide", "guide")
    get :show, params: { path: path_for(content_item), variant: "print" }

    assert_response :success
    assert_equal request.variant, [:print]
    assert_select "#guide-print"
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
    path = "government/case-studies/electric-cars]"

    stub_content_store_does_not_have_item("/#{path}")

    get :show, params: { path: }
    assert_response :not_found
  end

  test "returns 404 for item not in content store" do
    path = "government/case-studies/boost-chocolate-production"

    stub_content_store_does_not_have_item("/#{path}")

    get :show, params: { path: }
    assert_response :not_found
  end

  test "returns 404 if content store falls through to special route" do
    path = "government/item-not-here"

    content_item = content_store_has_schema_example("special_route", "special_route")
    content_item["base_path"] = "/government"

    stub_content_store_has_item("/#{path}", content_item)

    get :show, params: { path: }
    assert_response :not_found
  end

  test "returns 403 for access-limited item" do
    path = "government/case-studies/super-sekrit-document"
    url = "#{content_store_endpoint}/content/#{path}"
    stub_request(:get, url).to_return(status: 403, headers: {})

    get :show, params: { path: }
    assert_response :forbidden
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

  test "sets GOVUK-Account-Session-Flash in the Vary header" do
    content_item = content_store_has_schema_example("case_study", "case_study")
    get :show, params: { path: path_for(content_item) }

    assert response.headers["Vary"].include?("GOVUK-Account-Session-Flash")
  end

  %w[publication consultation detailed_guide call_for_evidence document_collection].each do |schema_name|
    test "#{schema_name} displays the subscription success banner when the 'email-subscription-success' flash is present" do
      example_name = %w[consultation call_for_evidence].include?(schema_name) ? "open_#{schema_name}" : schema_name
      content_item = content_store_has_schema_example(schema_name, example_name)

      request.headers["GOVUK-Account-Session"] = GovukPersonalisation::Flash.encode_session("session-id", %w[email-subscription-success])
      get :show, params: { path: path_for(content_item) }
      assert response.body.include?("subscribed to emails about this page")
    end

    test "#{schema_name} displays the unsubscribe success banner when the 'email-unsubscribe-success' flash is present" do
      example_name = %w[consultation call_for_evidence].include?(schema_name) ? "open_#{schema_name}" : schema_name
      content_item = content_store_has_schema_example(schema_name, example_name)

      request.headers["GOVUK-Account-Session"] = GovukPersonalisation::Flash.encode_session("session-id", %w[email-unsubscribe-success])
      get :show, params: { path: path_for(content_item) }
      assert response.body.include?("unsubscribed from emails about this page")
    end

    test "#{schema_name} displays the already subscribed success banner when the 'email-subscribe-already-subscribed' flash is present" do
      example_name = %w[consultation call_for_evidence].include?(schema_name) ? "open_#{schema_name}" : schema_name
      content_item = content_store_has_schema_example(schema_name, example_name)

      request.headers["GOVUK-Account-Session"] = GovukPersonalisation::Flash.encode_session("session-id", %w[email-subscription-already-subscribed])
      get :show, params: { path: path_for(content_item) }
      assert response.body.include?("already getting emails about this page")
    end
  end

  test "renders service_manual_guides" do
    content_item = content_store_has_schema_example("service_manual_guide", "service_manual_guide")

    get :show, params: { path: path_for(content_item) }
    assert_response :success
    assert_equal content_item["title"], assigns[:content_item].title
  end

  test "guides should tell slimmer to scope search results to the manual" do
    content_item = content_store_has_schema_example("service_manual_guide", "service_manual_guide")

    get :show, params: { path: path_for(content_item) }
    assert_equal(
      { filter_manual: "/service-manual" }.to_json,
      @response.headers[Slimmer::Headers::SEARCH_PARAMETERS_HEADER],
    )
  end

  test "the homepage should tell slimmer not to include a search box in the header" do
    content_item = content_store_has_schema_example("service_manual_homepage", "service_manual_homepage")

    get :show, params: { path: path_for(content_item) }
    assert_equal "true", @response.headers[Slimmer::Headers::REMOVE_SEARCH_HEADER]
  end

  def path_for(content_item, locale = nil)
    base_path = content_item["base_path"].sub(/^\//, "")
    base_path.gsub!(/\.#{locale}$/, "") if locale
    base_path
  end
end
