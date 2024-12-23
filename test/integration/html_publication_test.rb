require "test_helper"

class HtmlPublicationTest < ActionDispatch::IntegrationTest
  test "random but valid items do not error" do
    assert_nothing_raised { setup_and_visit_random_content_item }
  end

  test "html publications" do
    setup_and_visit_html_publication("published")

    within ".gem-c-inverse-header" do
      format_sub_type = @content_item["details"]["format_sub_type"]
      assert page.has_text?(format_sub_type) if format_sub_type.present?
      assert page.has_text?(@content_item["title"])

      assert page.has_text?("Published 17 January 2016")
    end

    within "#contents" do
      assert page.has_text?("Contents")
      assert page.has_css?(".gem-c-contents-list")
    end

    assert page.has_text?("The Environment Agency will normally put any responses it receives on the public register. This includes your name and contact details. Tell us if you don’t want your response to be public.")
  end

  test "html publications with meta data" do
    setup_and_visit_html_publication("print_with_meta_data")

    within "#contents" do
      assert page.find(".meta-data.meta-data--display-print", visible: false, text: "© Crown copyright #{@content_item['details']['public_timestamp'].to_date.year}")
      assert page.find(".meta-data.meta-data--display-print", visible: false, text: "ISBN: #{@content_item['details']['isbn']}")
    end
  end

  test "renders back to contents elements" do
    setup_and_visit_html_publication("published")
    assert page.has_css?(".app-c-back-to-top[href='#contents']")
  end

  test "prime minister office organisation html publication" do
    setup_and_visit_html_publication("prime_ministers_office")
    assert_has_component_organisation_logo_with_brand("executive-office", 4)
  end

  test "no contents are shown when headings are an empty list" do
    setup_and_visit_html_publication("prime_ministers_office")

    within ".gem-c-inverse-header" do
      assert_not page.has_text?("Contents")
    end
  end

  test "html publication with rtl text direction" do
    setup_and_visit_html_publication("arabic_translation")
    assert page.has_css?("#wrapper.direction-rtl"), "has .direction-rtl class on #wrapper element"
  end

  def assert_has_component_organisation_logo_with_brand(brand, index = 1)
    within(".organisation-logos__logo:nth-of-type(#{index})") do
      assert page.has_css?(".gem-c-organisation-logo.brand--#{brand}")
    end
  end

  test "historically political html publication" do
    setup_and_visit_html_publication("published_with_history_mode")

    within ".govuk-notification-banner__content" do
      assert page.has_text?("This was published under the 2010 to 2015 Conservative and Liberal Democrat coalition government")
    end
  end

  test "withdrawn html publication" do
    content_item = GovukSchemas::Example.find("html_publication", example_name: "prime_ministers_office")
    content_item["withdrawn_notice"] = {
      'explanation': "This is out of date",
      'withdrawn_at': "2014-08-09T11:39:05Z",
    }

    stub_content_store_has_item(content_item["links"]["parent"][0]["base_path"])
    stub_content_store_has_item("/government/publications/canada-united-kingdom-joint-declaration/canada-united-kingdom-joint-declaration", content_item.to_json)
    visit_with_cachebust "/government/publications/canada-united-kingdom-joint-declaration/canada-united-kingdom-joint-declaration"

    assert page.has_css?(".gem-c-notice__title", text: "This policy paper was withdrawn on 9 August 2014")
    assert page.has_css?(".gem-c-notice", text: "This is out of date")
  end

  test "if document has no parent document_type 'publication' is shown" do
    content_item = GovukSchemas::Example.find("html_publication", example_name: "prime_ministers_office")
    parent = content_item["links"]["parent"][0]
    parent["document_type"] = nil
    content_item["withdrawn_notice"] = {
      'explanation': "This is out of date",
      'withdrawn_at': "2014-08-09T11:39:05Z",
    }
    stub_content_store_has_item(parent["base_path"])
    stub_content_store_has_item("/government/publications/canada-united-kingdom-joint-declaration/canada-united-kingdom-joint-declaration", content_item.to_json)
    visit_with_cachebust "/government/publications/canada-united-kingdom-joint-declaration/canada-united-kingdom-joint-declaration"

    assert page.has_css?(".gem-c-notice__title", text: "This publication was withdrawn on 9 August 2014")
  end

  test "does not render with the single page notification button" do
    setup_and_visit_html_publication("published")
    assert_not page.has_css?(".gem-c-single-page-notification-button")
  end

  test "HTML publication that only applies to a set of nations, with alternative urls" do
    setup_and_visit_html_publication("national_applicability_alternative_url_html_publication")
    assert_has_devolved_nations_component("Applies to England, Scotland and Wales", [
      {
        text: "Publication for Northern Ireland",
        alternative_url: "http://www.dardni.gov.uk/news-dard-pa022-a-13-new-procedure-for",
      },
    ])
  end
end
