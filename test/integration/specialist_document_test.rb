require 'test_helper'

class SpecialistDocumentTest < ActionDispatch::IntegrationTest
  test "random but valid specialist documents do not error" do
    setup_and_visit_random_content_item(document_type: 'aaib_report')
    setup_and_visit_random_content_item(document_type: 'raib_report')
    setup_and_visit_random_content_item(document_type: 'tax_tribunal_decision')
    setup_and_visit_random_content_item(document_type: 'cma_case')
  end

  test "specialist document subtypes do not error" do
    setup_and_visit_content_item('aaib-reports')
    setup_and_visit_content_item('asylum-support-decision')
    setup_and_visit_content_item('business-finance-support-scheme')
    setup_and_visit_content_item('cma-cases')
    setup_and_visit_content_item('countryside-stewardship-grants')
    setup_and_visit_content_item('drug-safety-update')
    setup_and_visit_content_item('employment-appeal-tribunal-decision')
    setup_and_visit_content_item('employment-tribunal-decision')
    setup_and_visit_content_item('european-structural-investment-funds')
    setup_and_visit_content_item('international-development-funding')
    setup_and_visit_content_item('maib-reports')
    setup_and_visit_content_item('raib-reports')
    setup_and_visit_content_item('residential-property-tribunal-decision')
    setup_and_visit_content_item('service-standard-report')
    setup_and_visit_content_item('tax-tribunal-decision')
    setup_and_visit_content_item('utaac-decision')
  end

  test "renders title, description and body" do
    setup_and_visit_content_item('aaib-reports')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
    assert_has_component_govspeak(@content_item["details"]["body"])
  end

  test "returns example for residential tribunal decision" do
    setup_and_visit_content_item('residential-property-tribunal-decision')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
    assert_has_component_govspeak(@content_item["details"]["body"])
  end

  test "renders from in publisher metadata" do
    setup_and_visit_content_item('aaib-reports')

    assert_has_publisher_metadata_other(
      "From": {
        "Air Accidents Investigation Branch":
          "/government/organisations/air-accidents-investigation-branch"
      }
    )
  end

  test "renders published and updated in metadata" do
    setup_and_visit_content_item('countryside-stewardship-grants')

    assert_has_published_dates("Published 2 April 2015", "Last updated 29 March 2016")
  end

  test "renders change history in reverse chronological order" do
    setup_and_visit_content_item('countryside-stewardship-grants')

    within(".app-c-published-dates__change-history") do
      assert_match @content_item["details"]["change_history"].last["note"],
        page.find(".app-c-published-dates__change-item:first-child").text

      assert_match @content_item["details"]["change_history"].first["note"],
        page.find(".app-c-published-dates__change-item:last-child").text

      assert_equal all(".app-c-published-dates__change-item").size,
        @content_item["details"]["change_history"].size
    end
  end

  test "renders text facets correctly" do
    setup_and_visit_content_item('countryside-stewardship-grants')

    assert_has_important_metadata(
      "Grant type": { "Option": "/countryside-stewardship-grants?grant_type%5B%5D=option" },
      "Land use": {
        "Arable land": "/countryside-stewardship-grants?land_use%5B%5D=arable-land",
        "Water quality": "/countryside-stewardship-grants?land_use%5B%5D=water-quality",
      },
      "Tiers or standalone items": {
        "Higher Tier": "/countryside-stewardship-grants?tiers_or_standalone_items%5B%5D=higher-tier",
        "Mid Tier": "/countryside-stewardship-grants?tiers_or_standalone_items%5B%5D=mid-tier",
      },
      "Funding (per unit per year)": {
        "More than £500": "/countryside-stewardship-grants?funding_amount%5B%5D=more-than-500"
      }
    )
  end

  test "renders date facets correctly" do
    setup_and_visit_content_item('drug-device-alerts')

    assert_has_important_metadata("Issued": "6 July 2015")
    assert_footer_has_published_dates("Published 6 July 2015")
  end

  test "renders when no facet or finder" do
    setup_and_visit_content_item('business-finance-support-scheme')

    assert_has_published_dates("Published 9 July 2015")
  end

  test "renders a nested contents list" do
    setup_and_visit_content_item('countryside-stewardship-grants')

    assert page.has_css?("#contents .app-c-contents-list")
    assert page.has_css?(%(#contents .app-c-contents-list-with-body__link-wrapper
                          .app-c-contents-list-with-body__link-container a.app-c-back-to-top))

    within ".app-c-contents-list" do
      @content_item['details']['headers'].each do |heading|
        assert_nested_content_item(heading)
      end
    end
  end

  test "renders a nested contents list with level 2 and 3 headings only" do
    setup_and_visit_content_item('drug-device-alerts')

    within ".app-c-contents-list" do
      @content_item['details']['headers'].each do |heading|
        assert_nested_content_item(heading)
      end
    end
  end

  def assert_nested_content_item(heading)
    heading_level = heading["level"]
    selector = "a[href=\"##{heading['id']}\"]"
    text = heading["text"].gsub(/\:$/, '')

    if heading_level < 4
      assert page.has_css?(selector), "Failed to find an element matching: #{selector}"
      assert page.has_css?(selector, text: text), "Failed to find an element matching #{selector} with text: #{text}"
    else
      refute page.has_css?(selector), "Found a nested heading too deep, there should be no element matching: #{selector}"
    end

    if heading["headers"].present?
      heading["headers"].each do |h|
        assert_nested_content_item(h)
      end
    end
  end

  test 'renders no start button when not set' do
    setup_and_visit_content_item('aaib-reports')

    assert_no_component('button')
  end

  test 'renders start button' do
    setup_and_visit_content_item('business-finance-support-scheme')

    assert_component_locals(
      'button',
      start: true,
      href: 'http://www.bigissueinvest.com',
      info_text: 'on the Big Issue Invest website',
      text: 'Find out more'
    )
  end

  test 'does not render a contents list if there are fewer than three items in the contents list' do
    setup_and_visit_content_item('aaib-reports')

    refute page.has_css?('#contents .app-c-contents-list')
  end
end
