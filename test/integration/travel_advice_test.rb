require "test_helper"

class TravelAdviceTest < ActionDispatch::IntegrationTest
  test "random but valid items do not error" do
    setup_and_visit_random_content_item
  end

  test "travel advice header and navigation (without summary)" do
    setup_and_visit_content_item("full-country-without-summary")

    assert page.has_css?("title", visible: false, text: @content_item["title"])
    assert_has_component_title(@content_item["details"]["country"]["name"])

    assert page.has_css?("a[href=\"#{@content_item['details']['email_signup_link']}\"]", text: "Get email alerts")

    assert page.has_css?(".part-navigation-container nav li", count: @content_item["details"]["parts"].size)
    assert page.has_css?(".part-navigation-container nav li", text: "Safety and security")
    assert_not page.has_css?(".part-navigation li a", text: "Safety and security")

    parts_size = @content_item["details"]["parts"].size
    (@content_item["details"]["parts"][1..parts_size]).each do |part|
      assert page.has_css?(".part-navigation-container nav li a[href*=\"#{part['slug']}\"]", text: part["title"])
    end

    assert page.has_css?(".govuk-pagination")
    assert page.has_css?('.govuk-link.govuk-link--no-visited-state[href$="/print"]', text: "View a printable version of the whole guide")
  end

  test "travel advice first part has latest updates and map (without summary)" do
    setup_and_visit_content_item("full-country-without-summary")
    assert page.has_css?("h1", text: "Safety and security")
    assert page.has_text?("Public security is generally good, particularly in Tirana, and Albanians are very hospitable to visitors.")
    assert_has_component_metadata_pair("Still current at", Time.zone.today.strftime("%-d %B %Y"))
    assert_has_component_metadata_pair("Updated", Date.parse(@content_item["details"]["reviewed_at"]).strftime("%-d %B %Y"))

    within ".gem-c-metadata" do
      assert page.has_content?(@content_item["details"]["change_description"].gsub("Latest update: ", "").strip)
    end

    assert page.has_css?(".map img[src=\"#{@content_item['details']['image']['url']}\"]")
    assert page.has_css?(".map figcaption a[href=\"#{@content_item['details']['document']['url']}\"]", text: "Download map (PDF)")
  end

  test "travel advice part renders just that part (without summary)" do
    example = get_content_example("full-country-without-summary")
    first_part = example["details"]["parts"][1]
    setup_and_visit_travel_advice_part("full-country-without-summary", first_part["slug"])

    assert page.has_css?("title", visible: false, text: "#{first_part['title']} - #{@content_item['title']}")
    assert page.has_css?("h1", text: first_part["title"])
    assert page.has_text?("There is an underlying threat from terrorism. Attacks, although unlikely, could be indiscriminate, including places frequented by expatriates and foreign travellers.")

    assert_not page.has_css?(".map")
    assert_not page.has_css?(".gem-c-metadata")

    assert page.has_css?(".part-navigation-container nav li", text: first_part["title"])
    assert_not page.has_css?(".part-navigation-container nav li a", text: first_part["title"])
  end

  test "travel advice includes a discoverable atom feed link (without summary)" do
    setup_and_visit_content_item("full-country-without-summary")
    assert page.has_css?("link[type*='atom'][href='#{@content_item['base_path']}.atom']", visible: false)
  end

  test "travel advice does not render with the single page notification button (without summary)" do
    setup_and_visit_content_item("full-country-without-summary")
    assert_not page.has_css?(".gem-c-single-page-notification-button")
  end

  def setup_and_visit_travel_advice_part(name, part)
    @content_item = get_content_example(name).tap do |item|
      stub_content_store_has_item("#{item['base_path']}/#{part}", item.to_json)
      visit "#{item['base_path']}/#{part}"
    end
  end
end
