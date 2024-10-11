require "test_helper"

class SpecialistDocumentTest < ActionDispatch::IntegrationTest
  test "random specialist document schema formats do not error" do
    setup_and_visit_random_content_item(document_type: "aaib_report")
    setup_and_visit_random_content_item(document_type: "raib_report")
    setup_and_visit_random_content_item(document_type: "tax_tribunal_decision")
    setup_and_visit_random_content_item(document_type: "cma_case")
  end

  test "renders title, description and body" do
    setup_and_visit_content_item("aaib-reports")

    assert_has_component_title(@content_item["title"].strip)
    assert page.has_text?(@content_item["description"])
    assert page.has_text?("The gyroplane began to move forward against the brakes before sufficient rotor rpm had been achieved for takeoff.")
  end

  test "renders from in publisher metadata" do
    setup_and_visit_content_item("aaib-reports")

    assert_has_metadata({
      from: {
        "Air Accidents Investigation Branch":
        "/government/organisations/air-accidents-investigation-branch",
      },
    })
  end

  test "renders published and updated in metadata" do
    setup_and_visit_content_item("countryside-stewardship-grants")

    assert_has_published_dates("Published 2 April 2015", "Last updated 29 March 2016")
  end

  test "renders change history in reverse chronological order" do
    setup_and_visit_content_item("countryside-stewardship-grants")

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
    setup_and_visit_content_item("countryside-stewardship-grants")

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
        "More than £500": "/countryside-stewardship-grants?funding_amount%5B%5D=more-than-500",
      },
    )
  end

  test "renders date facets correctly" do
    setup_and_visit_content_item("drug-device-alerts")

    assert_has_important_metadata("Issued": "6 July 2015")
    assert_footer_has_published_dates("Published 6 July 2015")
  end

  test "renders when no facet or finder" do
    setup_and_visit_content_item("business-finance-support-scheme")

    assert_has_published_dates("Published 9 July 2015")
  end

  test "renders a nested contents list" do
    setup_and_visit_content_item("countryside-stewardship-grants")

    assert page.has_css?("#contents .gem-c-contents-list")
    assert page.has_css?(%(#contents .app-c-contents-list-with-body__link-wrapper
                          .app-c-contents-list-with-body__link-container a.app-c-back-to-top))

    within ".gem-c-contents-list" do
      @content_item["details"]["headers"].each do |heading|
        assert_nested_content_item(heading)
      end
    end
  end

  test "renders a nested contents list with level 2 and 3 headings only" do
    setup_and_visit_content_item("drug-device-alerts")

    within ".gem-c-contents-list" do
      @content_item["details"]["headers"].each do |heading|
        assert_nested_content_item(heading)
      end
    end
  end

  def assert_nested_content_item(heading)
    heading_level = heading["level"]
    selector = "a[href=\"##{heading['id']}\"]"
    text = heading["text"].gsub(/:$/, "")

    if heading_level < 4
      assert page.has_css?(selector), "Failed to find an element matching: #{selector}"
      assert page.has_css?(selector, text:), "Failed to find an element matching #{selector} with text: #{text}"
    else
      assert_not page.has_css?(selector), "Found a nested heading too deep, there should be no element matching: #{selector}"
    end

    if heading["headers"].present?
      heading["headers"].each do |h|
        assert_nested_content_item(h)
      end
    end
  end

  test "renders no start button when not set" do
    setup_and_visit_content_item("aaib-reports")

    assert_not page.has_css?(".gem-c-button", text: "Find out more")
  end

  test "renders start button" do
    setup_and_visit_content_item("business-finance-support-scheme")

    assert page.has_css?(".gem-c-button[href='http://www.bigissueinvest.com']", text: "Find out more")
    assert page.has_content?("on the Big Issue Invest website")
  end

  test "renders a content list" do
    setup_and_visit_content_item("aaib-reports")
    assert page.has_css?(".gem-c-contents-list", text: "Contents")
  end

  test "renders a link to statutory instruments finder" do
    setup_and_visit_content_item("eu-withdrawal-act-2018-statutory-instruments")

    assert page.has_css?(
      "a[href='/eu-withdrawal-act-2018-statutory-instruments']",
      text: "See all EU Withdrawal Act 2018 statutory instruments",
    )
  end

  test "does not render with the single page notification button" do
    setup_and_visit_content_item("aaib-reports")
    assert_not page.has_css?(".gem-c-single-page-notification-button")
  end
end
