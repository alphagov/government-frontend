require "test_helper"

class HelpPageTest < ActionDispatch::IntegrationTest
  test "renders title and body" do
    setup_and_visit_content_item("help_page")

    assert page.has_text?(@content_item["title"])
    assert page.has_text?("GOV.UK puts small files (known as ‘cookies’) onto your computer to collect information about how you browse the site.")
    assert_has_published_dates(@content_item["last_updated"])
  end

  test "sets noindex meta tag for '/help/cookie-details'" do
    @content_item = get_content_example("help_page").tap do |item|
      item["base_path"] = "/help/cookie-details"
      stub_content_store_has_item(item["base_path"], item.to_json)
      visit_with_cachebust(item["base_path"])
    end

    assert page.has_css?('meta[name="robots"][content="noindex"]', visible: false)
  end
end
