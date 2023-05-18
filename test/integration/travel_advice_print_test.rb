require "test_helper"

class TravelAdvicePrint < ActionDispatch::IntegrationTest
  test "it renders the print view" do
    setup_and_visit_travel_advice_print("full-country")
    assert page.has_css?("#travel-advice-print")
  end

  test "it is not indexable by search engines" do
    setup_and_visit_travel_advice_print("full-country")
    assert page.has_css?("meta[name='robots'][content='noindex, nofollow']", visible: false)
  end

  test "it renders the summary and all parts in the print view" do
    setup_and_visit_travel_advice_print("full-country")

    assert_has_component_metadata_pair("Still current at", Time.zone.today.strftime("%-d %B %Y"))
    assert_has_component_metadata_pair("Updated", Date.parse(@content_item["details"]["reviewed_at"]).strftime("%-d %B %Y"))

    within ".gem-c-metadata" do
      assert page.has_content?(@content_item["details"]["change_description"].gsub("Latest update: ", "").strip)
    end

    assert page.has_content?("Summary – the main opposition party has called for mass protests against the government in Tirana on 18 February 2017")
  end

  # These tests are for travel advice datasets that don't have summary
  # The tests above will be replaced by these tests after we've completed the migration
  # to remove summary from all travel advice data and moved the content to the first part
  # (later in this story):
  # https://trello.com/c/tua0TaRV/1225-remove-summary-from-travel-advice

  test "(without summary) it renders all other parts in the print view" do
    setup_and_visit_travel_advice_print("full-country-without-summary")
    parts = @content_item["details"]["parts"]

    assert_has_component_metadata_pair("Still current at", Time.zone.today.strftime("%-d %B %Y"))
    assert_has_component_metadata_pair("Updated", Date.parse(@content_item["details"]["reviewed_at"]).strftime("%-d %B %Y"))

    within ".gem-c-metadata" do
      assert page.has_content?(@content_item["details"]["change_description"].gsub("Latest update: ", "").strip)
    end

    assert page.has_css?("h1", text: "Safety and security")
    parts.each do |part|
      assert page.has_css?("h1", text: part["title"])
    end

    assert page.has_content?("There is an underlying threat from terrorism. Attacks, although unlikely, could be indiscriminate, including places frequented by expatriates and foreign travellers.")
  end

  def setup_and_visit_travel_advice_print(name)
    example = get_content_example_by_schema_and_name("travel_advice", name)
    @content_item = example.tap do |item|
      stub_content_store_has_item(item["base_path"], item.to_json)
      visit "#{item['base_path']}/print"
    end
  end
end
