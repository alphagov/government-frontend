require 'test_helper'

class TravelAdvicePrint < ActionDispatch::IntegrationTest
  test "it renders the print view" do
    setup_and_visit_travel_advice_print('full-country')
    assert page.has_css?("#travel-advice-print")
  end

  test "it is not indexable by search engines" do
    setup_and_visit_travel_advice_print('full-country')
    assert page.has_css?("meta[name='robots'][content='noindex, nofollow']", visible: false)
  end

  test "it renders the summary and all parts in the print view" do
    setup_and_visit_travel_advice_print('full-country')
    parts = @content_item['details']['parts']

    assert_has_component_metadata_pair("Still current at", Date.today.strftime("%-d %B %Y"))
    assert_has_component_metadata_pair("Updated", Date.parse(@content_item["details"]["reviewed_at"]).strftime("%-d %B %Y"))

    within ".gem-c-metadata" do
      assert page.has_content?(@content_item['details']['change_description'].gsub('Latest update: ', '').strip)
    end

    assert page.has_css?("h1", text: 'Summary')
    parts.each do |part|
      assert page.has_css?("h1", text: part['title'])
    end

    assert page.has_content?("Summary – the main opposition party has called for mass protests against the government in Tirana on 18 February 2017")
  end

  def setup_and_visit_travel_advice_print(name)
    example = get_content_example_by_schema_and_name('travel_advice', name)
    @content_item = example.tap do |item|
      content_store_has_item(item["base_path"], item.to_json)
      visit "#{item['base_path']}/print"
    end
  end
end
