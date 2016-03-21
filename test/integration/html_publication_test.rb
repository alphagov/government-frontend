require 'test_helper'

class HtmlPublicationTest < ActionDispatch::IntegrationTest
  test "html publications" do
    setup_and_visit_content_item('published')
    assert page.has_text?("See more information about this Notice")

    within ".publication-header" do
      assert page.has_text?(@content_item["details"]["format_sub_type"])
      assert page.has_text?(@content_item["title"])

      assert page.has_text?("Published 17 January 2016")

      assert page.has_text?("Contents")
      assert page.has_css?('ol.unnumbered')
    end

    within ".organisation-logos" do
      assert page.has_text?(@content_item["links"]["organisations"][0]["title"])
    end

    assert_has_component_govspeak_html_publication(@content_item["details"]["body"])
  end

  test "prime minister office organisation html publication" do
    setup_and_visit_content_item("prime_ministers_office")
    assert_has_component_organisation_logo_with_brand("executive-office", 4)
  end

  def assert_has_component_govspeak_html_publication(content)
    within shared_component_selector("govspeak_html_publication") do
      assert_equal content, JSON.parse(page.text).fetch("content")
    end
  end

  def assert_has_component_organisation_logo_with_brand(brand, index = 1)
    within("li.organisation-logo:nth-of-type(#{index}) #{shared_component_selector('organisation_logo')}") do
      assert_equal brand, JSON.parse(page.text).fetch("organisation").fetch("brand")
    end
  end
end
