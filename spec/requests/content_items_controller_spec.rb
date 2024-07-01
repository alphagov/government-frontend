RSpec.describe(ContentItemsController, type: :request) do
  include GovukAbTesting::MinitestHelpers

  it "routes paths with no format or locale" do
    assert_routing("/government/news/statement-the-status-of-eu-nationals-in-the-uk", controller: "content_items", action: "show", path: "government/news/statement-the-status-of-eu-nationals-in-the-uk")
  end

  it "route paths for all supported locales" do
    I18n.available_locales.each do |locale|
      assert_routing("/government/news/statement-the-status-of-eu-nationals-in-the-uk.#{locale}", controller: "content_items", action: "show", path: "government/news/statement-the-status-of-eu-nationals-in-the-uk", locale: locale.to_s)
    end
  end

  it "routes paths with just format" do
    assert_routing("/government/news/statement-the-status-of-eu-nationals-in-the-uk.atom", controller: "content_items", action: "show", path: "government/news/statement-the-status-of-eu-nationals-in-the-uk", format: "atom")
  end

  it "routes paths with format and locale" do
    assert_routing("/government/news/statement-the-status-of-eu-nationals-in-the-uk.es.atom", controller: "content_items", action: "show", path: "government/news/statement-the-status-of-eu-nationals-in-the-uk", format: "atom", locale: "es")
  end

  it "routes paths with print variant" do
    assert_routing("/government/news/statement-the-status-of-eu-nationals-in-the-uk/print", controller: "content_items", action: "show", path: "government/news/statement-the-status-of-eu-nationals-in-the-uk", variant: "print")
  end

  it "redirects route with invalid parts to base path" do
    content_item = content_store_has_schema_example("travel_advice", "full-country")
    invalid_part_path = "#{path_for(content_item)}/not-a-valid-part"
    stub_request(:get, /#{invalid_part_path}/).to_return(status: 200, body: content_item.to_json, headers: {})
    get "/#{invalid_part_path}"

    expect(response).to redirect_to(content_item["base_path"])
  end

  it "redirects route for first path to base path" do
    content_item = content_store_has_schema_example("guide", "guide")
    invalid_part_path = "#{path_for(content_item)}/#{content_item['details']['parts'].first['slug']}"
    stub_request(:get, /#{invalid_part_path}/).to_return(status: 200, body: content_item.to_json, headers: {})
    allow_any_instance_of(ContentItemsController).to receive(:page_in_scope?).and_return(false)
    get "/#{invalid_part_path}"

    expect(response).to redirect_to(content_item["base_path"])
  end

  it "returns HTML when an unspecific accepts header is requested (eg by IE8 and below)" do
    content_item = content_store_has_schema_example("travel_advice", "full-country")
    get "/#{path_for(content_item)}", headers: { Accept: "*/*" }

    expect(response.headers["Content-Type"]).to(match(/text\/html/))
    expect(response.status).to eq(200)
    assert_select("#wrapper")
  end

  it "returns a 406 for XMLHttpRequests without an Accept header set to a supported format" do
    content_item = content_store_has_schema_example("case_study", "case_study")
    get "/#{path_for(content_item)}", headers: { "X-Requested-With" => "XMLHttpRequest", "Accept" => nil }

    expect(response.status).to eq(406)
  end

  it "returns a 406 for unsupported format requests, eg text/javascript" do
    content_item = content_store_has_schema_example("case_study", "case_study")
    get "/#{path_for(content_item)}", headers: { Accept: "text/javascript" }

    expect(response.status).to eq(406)
  end

  it "gets an item from content store" do
    content_item = content_store_has_schema_example("case_study", "case_study")
    get "/#{path_for(content_item)}"

    expect(response.status).to eq(200)
    expect(assigns[:content_item].title).to(eq(content_item["title"]))
  end

  it "gets an item from content store and keeps existing ordered_related_items when links already exist" do
    content_item = content_store_has_schema_example("guide", "guide")
    get "/#{path_for(content_item)}"

    expect(response.status).to eq(200)
    expect(content_item["links"]["ordered_related_items"]).not_to be_empty
    expect(content_item["links"]["suggested_ordered_related_items"]).not_to be_empty
    expect(assigns[:content_item].content_item["links"]["ordered_related_items"]).to eq(content_item["links"]["ordered_related_items"])
  end

  it "gets an item from content store and does not change ordered_related_items when link overrides exist" do
    content_item = content_store_has_schema_example("guide", "guide-with-related-link-overrides")
    get "/#{path_for(content_item)}"

    expect(response.status).to eq(200)
    expect(content_item["links"]["ordered_related_items"]).to(be_nil)
    expect(content_item["links"]["ordered_related_items_overrides"]).not_to be_empty
    expect(content_item["links"]["suggested_ordered_related_items"]).not_to be_empty
    expect(content_item["links"]["ordered_related_items"]).to(be_nil)
  end

  it "gets an item from content store and replaces ordered_related_items there are no existing links or overrides" do
    content_item = content_store_has_schema_example("case_study", "case_study")
    get "/#{path_for(content_item)}"

    expect(response.status).to eq(200)
    expect(content_item["links"]["ordered_related_items"]).to(be_empty)
    expect(content_item["links"]["suggested_ordered_related_items"]).not_to be_empty
    expect(content_item["links"]["suggested_ordered_related_items"]).to eq(assigns[:content_item].content_item["links"]["ordered_related_items"])
  end

  it "sets the expiry as sent by content-store" do
    content_item = content_store_has_schema_example("case_study", "case_study")
    stub_content_store_has_item(content_item["base_path"], content_item, max_age: 20)
    get "/#{path_for(content_item)}"

    expect(response.status).to eq(200)
    expect(response.headers["Cache-Control"]).to eq("max-age=20, public")
  end

  it "sets a longer cache-control header for travel advice atom feeds" do
    content_item = content_store_has_schema_example("travel_advice", "full-country")
    get "/#{path_for(content_item)}", params: { format: :atom }

    expect(response.status).to eq(200)
    expect(response.headers["Cache-Control"]).to eq("max-age=300, public")
  end

  it "honours cache-control private items" do
    content_item = content_store_has_schema_example("case_study", "case_study")
    stub_content_store_has_item(content_item["base_path"], content_item, private: true)
    get "/#{path_for(content_item)}"

    expect(response.status).to eq(200)
    expect(response.headers["Cache-Control"]).to eq("max-age=900, private")
  end

  it "renders translated content items in their locale" do
    content_item = content_store_has_schema_example("case_study", "translated")
    locale = content_item["locale"]
    translated_schema_name = I18n.t("content_item.schema_name.case_study", count: 1, locale:)
    get "/#{path_for(content_item, locale)}", params: { locale: }

    expect(response.status).to eq(200)
    assert_select("title", /#{translated_schema_name}/)
  end

  it "renders atom feeds" do
    content_item = content_store_has_schema_example("travel_advice", "full-country")
    get "/#{path_for(content_item)}", params: { format: :atom }

    expect(response.status).to eq(200)
    assert_select("feed title", "Travel Advice Summary")
  end

  it "renders print variants" do
    content_item = content_store_has_schema_example("travel_advice", "full-country")
    get "/#{path_for(content_item)}", params: { variant: :print }

    assert_select("#travel-advice-print")
  end

  it "gets an item from content store even when url contains multi-byte UTF8 character" do
    content_item = content_store_has_schema_example("case_study", "case_study")
    utf8_path = "government/case-studies/caf\u00E9-culture"
    content_item["base_path"] = "/#{utf8_path}"
    stub_content_store_has_item(content_item["base_path"], content_item)
    get "/#{CGI.escape(utf8_path)}"

    expect(response.status).to eq(200)
  end

  it "returns 404 for invalid url" do
    path = "foreign-travel-advice/egypt]"
    stub_content_store_does_not_have_item("/#{path}")
    get "/#{CGI.escape(path)}"

    expect(response.status).to eq(404)
  end

  it "returns 404 if the item is not in content store" do
    path = "government/case-studies/boost-chocolate-production"
    stub_content_store_does_not_have_item("/#{path}")
    get "/#{path}"

    expect(response.status).to eq(404)
  end

  it "returns 404 if content store falls through to special route" do
    path = "government/item-not-here"
    content_item = content_store_has_schema_example("special_route", "special_route")
    content_item["base_path"] = "/government"
    stub_content_store_has_item("/#{path}", content_item)
    get "/#{path}"

    expect(response.status).to eq(404)
  end

  it "returns 403 for access-limited item" do
    path = "government/case-studies/super-sekrit-document"
    url = "#{content_store_endpoint}/content/#{path}"
    stub_request(:get, url).to_return(status: 403, headers: {})
    get "/#{path}"

    expect(response.status).to eq(403)
  end

  it "returns 406 for schema types which don't support provided format" do
    content_item_without_atom = content_store_has_schema_example("case_study", "case_study")
    get "/#{path_for(content_item_without_atom)}", params: { format: "atom" }

    expect(response.status).to eq(406)
  end

  it "returns 410 for content items that are gone" do
    stub_content_store_has_gone_item("/gone-item")
    get "/gone-item"

    expect(response.status).to eq(410)
  end

  it "returns a redirect when content item is a redirect" do
    content_item = content_store_has_schema_example("redirect", "redirect")
    stub_content_store_has_item("/406beacon", content_item)
    get "/406beacon"

    expect(response).to redirect_to("https://www.test.gov.uk/maritime-safety-weather-and-navigation/register-406-mhz-beacons?query=answer#fragment")
  end

  it "returns a prefixed redirect when content item is a prefix redirect" do
    content_item = content_store_has_schema_example("redirect", "redirect")
    stub_content_store_has_item("/406beacon/prefix/to-preserve", content_item)
    get "/406beacon/prefix/to-preserve"

    expect(response).to redirect_to("https://www.test.gov.uk/new-406-beacons-destination/to-preserve")
  end

  it "sets the Access-Control-Allow-Origin header for atom pages" do
    content_store_has_schema_example("travel_advice", "full-country")
    get "/foreign-travel-advice/albania", params: { format: "atom" }

    expect(response.headers["Access-Control-Allow-Origin"]).to eq("*")
  end

  it "sets GOVUK-Account-Session-Flash in the Vary header" do
    content_item = content_store_has_schema_example("case_study", "case_study")
    get "/#{path_for(content_item)}"

    expect(response.headers["Vary"].include?("GOVUK-Account-Session-Flash")).to eq(true)
  end

  %w[publication consultation detailed_guide call_for_evidence].each do |schema_name|
    it "#{schema_name} displays the subscription success banner when the 'email-subscription-success' flash is present" do
      example_name = if %w[consultation call_for_evidence].include?(schema_name)
                       "open_#{schema_name}"
                     else
                       schema_name
                     end
      content_item = content_store_has_schema_example(schema_name, example_name)
      get(
        "/#{path_for(content_item)}",
        headers: { "GOVUK-Account-Session" => GovukPersonalisation::Flash.encode_session("session-id", %w[email-subscription-success]) },
      )

      expect(response.body).to include("subscribed to emails about this page")
    end

    it "#{schema_name} displays the unsubscribe success banner when the 'email-unsubscribe-success' flash is present" do
      example_name = if %w[consultation call_for_evidence].include?(schema_name)
                       "open_#{schema_name}"
                     else
                       schema_name
                     end
      content_item = content_store_has_schema_example(schema_name, example_name)
      get(
        "/#{path_for(content_item)}",
        headers: { "GOVUK-Account-Session" => GovukPersonalisation::Flash.encode_session("session-id", %w[email-unsubscribe-success]) },
      )

      expect(response.body).to include("unsubscribed from emails about this page")
    end

    it "#{schema_name} displays the already subscribed success banner when the 'email-subscribe-already-subscribed' flash is present" do
      example_name = if %w[consultation call_for_evidence].include?(schema_name)
                       "open_#{schema_name}"
                     else
                       schema_name
                     end
      content_item = content_store_has_schema_example(schema_name, example_name)
      get(
        "/#{path_for(content_item)}",
        headers: { "GOVUK-Account-Session" => GovukPersonalisation::Flash.encode_session("session-id", %w[email-subscription-already-subscribed]) },
      )

      expect(response.body).to include("already getting emails about this page")
    end
  end

  it "renders service_manual_guides" do
    content_item = content_store_has_schema_example("service_manual_guide", "service_manual_guide")
    get "/#{path_for(content_item)}"

    expect(response.status).to eq(200)
    expect(assigns[:content_item].title).to eq(content_item["title"])
  end
end
