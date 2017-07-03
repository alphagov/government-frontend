require 'test_helper'

class TravelAdvicePrint < ActionDispatch::IntegrationTest
  test "it renders the print view" do
    setup_and_visit_travel_advice_print('full-country')
    assert page.has_css?(".travel-advice-print")
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

    within shared_component_selector("metadata") do
      component_args = JSON.parse(page.text)
      latest_update = component_args["other"].fetch("Latest update")

      assert latest_update.include?('<p>')
      assert latest_update.include?(@content_item['details']['change_description'].gsub('Latest update: ', ''))
    end

    assert page.has_css?("h1", text: 'Summary')
    parts.each do |part|
      assert page.has_css?("h1", text: part['title'])
    end

    page.all(shared_component_selector("govspeak")).each_with_index do |govspeak_component, i|
      within(govspeak_component) do
        content_passed_to_component = JSON.parse(page.text).fetch("content").gsub(/\s+/, ' ')
        if i == 0
          assert_equal @content_item["details"]["summary"].gsub(/\s+/, ' '), content_passed_to_component
        else
          assert_equal parts[i - 1]['body'].gsub(/\s+/, ' '), content_passed_to_component
        end
      end
    end
  end

  def setup_and_visit_travel_advice_print(name)
    example = get_content_example_by_schema_and_name('travel_advice', name)
    @content_item = example.tap do |item|
      content_store_has_item(item["base_path"], item.to_json)
      visit "#{item['base_path']}/print"
    end
  end
end
