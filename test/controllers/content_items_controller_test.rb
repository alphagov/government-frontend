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
    content_item = content_store_has_schema_example("worldwide_organisation", "worldwide_organisation")

    get :show,
        params: {
          path: path_for(content_item),
        }

    assert_response :not_acceptable
  end

  test "returns a 406 for unsupported format requests, eg text/javascript" do
    request.headers["Accept"] = "text/javascript"
    content_item = content_store_has_schema_example("worldwide_organisation", "worldwide_organisation")

    get :show,
        params: {
          path: path_for(content_item),
        }

    assert_response :not_acceptable
  end

  test "gets item from content store" do
    content_item = content_store_has_schema_example("worldwide_organisation", "worldwide_organisation")

    get :show, params: { path: path_for(content_item) }
    assert_response :success
    assert_equal content_item["title"], assigns[:content_item].title
  end

  test "sets prometheus labels on the rack env" do
    content_item = content_store_has_schema_example("worldwide_organisation", "worldwide_organisation")

    get :show, params: { path: path_for(content_item) }
    assert_response :success
    assert_equal @request.env["govuk.prometheus_labels"], { document_type: "worldwide_organisation", schema_name: "worldwide_organisation" }
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

  test "sets the expiry as sent by content-store" do
    content_item = content_store_has_schema_example("worldwide_organisation", "worldwide_organisation")
    stub_content_store_has_item(content_item["base_path"], content_item, max_age: 20)

    get :show, params: { path: path_for(content_item) }
    assert_response :success
    assert_equal "max-age=20, public", @response.headers["Cache-Control"]
  end

  test "honours cache-control private items" do
    content_item = content_store_has_schema_example("worldwide_organisation", "worldwide_organisation")
    stub_content_store_has_item(content_item["base_path"], content_item, private: true)

    get :show, params: { path: path_for(content_item) }
    assert_response :success
    assert_equal "max-age=900, private", @response.headers["Cache-Control"]
  end

  test "renders translated content items in their locale" do
    content_item = content_store_has_schema_example("corporate_information_page", "corporate_information_page_translated_custom_logo")
    locale = content_item["locale"]

    get :show, params: { path: path_for(content_item, locale), locale: }

    assert_response :success
    assert_select "title", "Defnydd o gyfryngau cymdeithasol - Land Registry - GOV.UK"
  end

  test "gets item from content store even when url contains multi-byte UTF8 character" do
    content_item = content_store_has_schema_example("worldwide_organisation", "worldwide_organisation")
    utf8_path    = "/world/uk-caf\u00e9-in-country"
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
    content_item = content_store_has_schema_example("worldwide_organisation", "worldwide_organisation")
    get :show, params: { path: path_for(content_item) }

    assert response.headers["Vary"].include?("GOVUK-Account-Session-Flash")
  end

  %w[publication consultation].each do |schema_name|
    test "#{schema_name} displays the subscription success banner when the 'email-subscription-success' flash is present" do
      example_name = %w[consultation].include?(schema_name) ? "open_#{schema_name}" : schema_name
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

  def path_for(content_item, locale = nil)
    base_path = content_item["base_path"].sub(/^\//, "")
    base_path.gsub!(/\.#{locale}$/, "") if locale
    base_path
  end
end
