require "test_helper"

class TravelAdviceTest < ActionDispatch::IntegrationTest
  test "random but valid items do not error" do
    setup_and_visit_random_content_item
  end

  test "travel advice header and navigation" do
    setup_and_visit_content_item("full-country")

    assert page.has_css?("title", visible: false, text: @content_item["title"])
    assert_has_component_title(@content_item["details"]["country"]["name"])

    assert page.has_css?("a[href=\"#{@content_item['details']['email_signup_link']}\"]", text: "Get email alerts")
    assert page.has_css?("a[href=\"#{@content_item['base_path']}.atom\"]", text: "Subscribe to feed")

    assert page.has_css?(".part-navigation ol", count: 2)
    assert page.has_css?(".part-navigation li", count: @content_item["details"]["parts"].size + 1)
    assert page.has_css?(".part-navigation li", text: "Summary")
    assert_not page.has_css?(".part-navigation li a", text: "Summary")

    @content_item["details"]["parts"].each do |part|
      assert page.has_css?(".part-navigation li a[href*=\"#{part['slug']}\"]", text: part["title"])
    end

    assert page.has_css?(".gem-c-pagination")
    assert page.has_css?('.gem-c-print-link a[href$="/print"]')
  end

  test "travel advice summary has latest updates and map" do
    setup_and_visit_content_item("full-country")

    assert page.has_css?("h1", text: "Summary")
    assert page.has_text?("The main opposition party has called for mass protests against the government in Tirana on 18 February 2017. The political atmosphere is likely to become changeable as the country approaches national elections on 18 June 2017.")

    assert_has_component_metadata_pair("Still current at", Time.zone.today.strftime("%-d %B %Y"))
    assert_has_component_metadata_pair("Updated", Date.parse(@content_item["details"]["reviewed_at"]).strftime("%-d %B %Y"))

    within ".gem-c-metadata" do
      assert page.has_content?(@content_item["details"]["change_description"].gsub("Latest update: ", "").strip)
    end

    assert page.has_css?(".map img[src=\"#{@content_item['details']['image']['url']}\"]")
    assert page.has_css?(".map figcaption a[href=\"#{@content_item['details']['document']['url']}\"]", text: "Download map (PDF)")
  end

  test "travel advice part renders just that part" do
    example = get_content_example("full-country")
    first_part = example["details"]["parts"].first
    setup_and_visit_travel_advice_part("full-country", first_part["slug"])

    assert page.has_css?("title", visible: false, text: "#{first_part['title']} - #{@content_item['title']}")
    assert page.has_css?("h1", text: first_part["title"])
    assert page.has_text?("Public security is generally good, particularly in Tirana, and Albanians are very hospitable to visitors.")

    assert_not page.has_css?(".map")
    assert_not page.has_css?(".gem-c-metadata")

    assert page.has_css?(".part-navigation li", text: first_part["title"])
    assert_not page.has_css?(".part-navigation li a", text: first_part["title"])
  end

  test "travel advice includes a discoverable atom feed link" do
    setup_and_visit_content_item("full-country")
    assert page.has_css?("link[type*='atom'][href='#{@content_item['base_path']}.atom']", visible: false)
  end

  def setup_and_visit_travel_advice_part(name, part)
    @content_item = get_content_example(name).tap do |item|
      stub_content_store_has_item("#{item['base_path']}/#{part}", item.to_json)
      visit "#{item['base_path']}/#{part}"
    end
  end
end
