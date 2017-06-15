require 'test_helper'

class HtmlPublicationTest < ActionDispatch::IntegrationTest
  test "random but valid items do not error" do
    10.times do
      setup_and_visit_random_content_item
    end
  end

  test "html publications" do
    setup_and_visit_content_item('published')

    within ".publication-header" do
      assert page.has_text?(@content_item["details"]["format_sub_type"])
      assert page.has_text?(@content_item["title"])

      assert page.has_text?("Published 17 January 2016")
    end

    within ".sidebar-with-body" do
      assert page.has_text?("Contents")
      assert page.has_css?('ol.contents-list')
    end

    within ".organisation-logos" do
      assert page.has_text?(@content_item["links"]["organisations"][0]["title"])
    end

    assert_has_component_govspeak_html_publication(@content_item["details"]["body"])
  end

  test "html publications with meta data" do
    setup_and_visit_content_item("print_with_meta_data")

    within ".publication-header" do
      assert page.find(".print-meta-data", visible: false)

      assert page.has_no_text?("© Crown copyright #{@content_item['details']['public_timestamp'].to_date.year}")
      assert page.has_no_text?("Any enquiries regarding this publication should be sent to us at:")
      assert page.has_no_text?((@content_item['details']['print_meta_data_contact_address']).to_s)
      assert page.has_no_text?("Print ISBN: #{@content_item['details']['isbn']}")
      assert page.has_no_text?("Web ISBN: #{@content_item['details']['web_isbn']}")
    end
  end

  test "html publications with meta data - print version" do
    setup_and_visit_content_item("print_with_meta_data", "?medium=print")

    within ".publication-header" do
      assert page.find(".print-meta-data", visible: true)

      assert page.has_text?("© Crown copyright #{@content_item['details']['public_timestamp'].to_date.year}")
      assert page.has_text?("Any enquiries regarding this publication should be sent to us at:")
      assert page.has_text?((@content_item['details']['print_meta_data_contact_address']).to_s)
      assert page.has_text?("Print ISBN: #{@content_item['details']['isbn']}")
    end
  end

  test "prime minister office organisation html publication" do
    setup_and_visit_content_item("prime_ministers_office")
    assert_has_component_organisation_logo_with_brand("executive-office", 4)
  end

  test "no contents are shown when headings are an empty list" do
    setup_and_visit_content_item("prime_ministers_office")

    within ".publication-header" do
      refute page.has_text?("Contents")
    end
  end

  test "html publication with rtl text direction" do
    setup_and_visit_content_item("arabic_translation")
    assert page.has_css?(".publication-header.direction-rtl"), "has .direction-rtl class on .publication-header element"
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
