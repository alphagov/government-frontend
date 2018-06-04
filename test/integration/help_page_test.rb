require 'test_helper'

class HelpPageTest < ActionDispatch::IntegrationTest
  test "renders title and body" do
    setup_and_visit_content_item('help_page')

    assert page.has_text?(@content_item["title"])
    assert page.has_text?("GOV.UK puts small files (known as ‘cookies’) onto your computer to collect information about how you browse the site.")
    assert_has_published_dates(@content_item["last_updated"])
  end
end
