require 'test_helper'

class HtmlPublicationTest < ActionDispatch::IntegrationTest
  test "random but valid items do not error" do
    10.times do
      setup_and_visit_random_content_item
    end
  end

  test "html publications" do
    setup_and_visit_content_item('published')

    within ".app-c-publication-header" do
      assert page.has_text?(@content_item["details"]["format_sub_type"])
      assert page.has_text?(@content_item["title"])

      assert page.has_text?("Published 17 January 2016")
    end

    within ".sidebar-with-body" do
      assert page.has_text?("Contents")
      assert page.has_css?('.app-c-contents-list')
    end

    within ".organisation-logos" do
      assert page.has_text?(@content_item["links"]["organisations"][0]["title"])
    end

    assert_has_component_govspeak_html_publication(@content_item["details"]["body"])
  end

  test "html publications with meta data" do
    setup_and_visit_content_item("print_with_meta_data")

    within ".grid-row" do
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

    within ".grid-row" do
      assert page.find(".print-meta-data", visible: true)

      assert page.has_text?("© Crown copyright #{@content_item['details']['public_timestamp'].to_date.year}")
      assert page.has_text?("Any enquiries regarding this publication should be sent to us at:")
      assert page.has_text?((@content_item['details']['print_meta_data_contact_address']).to_s)
      assert page.has_text?("Print ISBN: #{@content_item['details']['isbn']}")
    end
  end

  test "renders back to contents elements" do
    setup_and_visit_content_item('published')
    assert page.has_css?(".app-c-back-to-top[href='#contents']")
  end

  test "prime minister office organisation html publication" do
    setup_and_visit_content_item("prime_ministers_office")
    assert_has_component_organisation_logo_with_brand("executive-office", 4)
  end

  test "no contents are shown when headings are an empty list" do
    setup_and_visit_content_item("prime_ministers_office")

    within ".app-c-publication-header" do
      refute page.has_text?("Contents")
    end
  end

  test "html publication with rtl text direction" do
    setup_and_visit_content_item("arabic_translation")
    assert page.has_css?("#wrapper.direction-rtl"), "has .direction-rtl class on #wrapper element"
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

  test "withdrawn html publication" do
    content_item = GovukSchemas::Example.find('html_publication', example_name: 'prime_ministers_office')
    content_item['withdrawn_notice'] = {
      'explanation': 'This is out of date',
      'withdrawn_at': '2014-08-09T11:39:05Z'
    }

    content_store_has_item("/government/publications/canada-united-kingdom-joint-declaration/canada-united-kingdom-joint-declaration", content_item.to_json)
    visit "/government/publications/canada-united-kingdom-joint-declaration/canada-united-kingdom-joint-declaration"

    assert page.has_css?(".app-c-notice__title", text: "This policy paper was withdrawn on 9 August 2014")
    assert page.has_css?(".app-c-notice", text: "This is out of date")
  end

  test "if document has no parent document_type 'publication' is shown" do
    content_item = GovukSchemas::Example.find('html_publication', example_name: 'prime_ministers_office')
    content_item['links']['parent'][0]['document_type'] = nil
    content_item['withdrawn_notice'] = {
      'explanation': 'This is out of date',
      'withdrawn_at': '2014-08-09T11:39:05Z'
    }

    content_store_has_item("/government/publications/canada-united-kingdom-joint-declaration/canada-united-kingdom-joint-declaration", content_item.to_json)
    visit "/government/publications/canada-united-kingdom-joint-declaration/canada-united-kingdom-joint-declaration"

    assert page.has_css?(".app-c-notice__title", text: "This publication was withdrawn on 9 August 2014")
  end
end
