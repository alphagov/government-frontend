require 'test_helper'

class TravelAdviceTest < ActionDispatch::IntegrationTest
  test "travel advice header and navigation" do
    setup_and_visit_content_item('full-country')

    assert page.has_css?("title", visible: false, text: @content_item['title'])
    assert_has_component_title(@content_item["details"]["country"]["name"])

    assert page.has_css?("a[href=\"#{@content_item['details']['email_signup_link']}\"]", text: "Get email alerts")
    assert page.has_css?("a[href=\"#{@content_item['base_path']}.atom\"]", text: "Subscribe to feed")

    assert page.has_css?('.part-navigation ol', count: 2)
    assert page.has_css?('.part-navigation li', count: @content_item['details']['parts'].size + 1)
    assert page.has_css?('.part-navigation li', text: 'Summary')
    refute page.has_css?('.part-navigation li a', text: 'Summary')

    @content_item['details']['parts'].each do |part|
      assert page.has_css?(".part-navigation li a[href*=\"#{part['slug']}\"]", text: part['name'])
    end

    assert page.has_css?('.print-link a[href$="/print"]')
  end

  test "travel advice summary has latest updates and map" do
    setup_and_visit_content_item('full-country')

    assert page.has_css?("h1", text: "Summary")
    assert_has_component_govspeak(@content_item["details"]["summary"])

    assert_has_component_metadata_pair("Still current at", Date.today.strftime("%-d %B %Y"))
    assert_has_component_metadata_pair("Updated", Date.parse(@content_item["details"]["reviewed_at"]).strftime("%-d %B %Y"))

    within shared_component_selector("metadata") do
      component_args = JSON.parse(page.text)
      latest_update = component_args["other"].fetch("Latest update")

      assert latest_update.include?('<p>')
      assert latest_update.include?(@content_item['details']['change_description'].gsub('Latest update: ', ''))
    end

    assert page.has_css?(".map img[src=\"#{@content_item['details']['image']['url']}\"]")
    assert page.has_css?(".map figcaption a[href=\"#{@content_item['details']['document']['url']}\"]", text: "Download map (PDF)")
  end

  test "travel advice part renders just that part" do
    example = JSON.parse(get_content_example('full-country'))
    first_part = example['details']['parts'].first
    setup_and_visit_travel_advice_part('full-country', first_part['slug'])

    assert page.has_css?("title", visible: false, text: "#{first_part['title']} - #{@content_item['title']}")
    assert page.has_css?("h1", text: first_part['title'])
    assert_has_component_govspeak(first_part['body'])

    refute page.has_css?(".map")
    refute page.has_css?(shared_component_selector("metadata"))

    assert page.has_css?('.part-navigation li', text: first_part['title'])
    refute page.has_css?('.part-navigation li a', text: first_part['title'])
  end

  test "travel advice includes a discoverable atom feed link" do
    setup_and_visit_content_item('full-country')
    assert page.has_css?("link[type*='atom'][href='#{@content_item['base_path']}.atom']", visible: false)
  end

  def setup_and_visit_travel_advice_part(name, part)
    @content_item = JSON.parse(get_content_example(name)).tap do |item|
      content_store_has_item(item["base_path"], item.to_json)
      visit "#{item['base_path']}/#{part}"
    end
  end
end
