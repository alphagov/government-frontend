require "test_helper"

class RecruitmentBannerTest < ActionDispatch::IntegrationTest
  test "Visa test recruitment banner is displayed on pages of interest" do
    guide = GovukSchemas::Example.find("guide", example_name: "guide")

    pages_of_interest =
      [
        "/apply-to-come-to-the-uk",
        "/healthcare-immigration-application",
        "/tb-test-visa",
        "/faster-decision-visa-settlement",
        "/skilled-worker-visa",
        "/health-care-worker-visa",
        "/temporary-worker-charity-worker-visa",
        "/seasonal-worker-visa",
        "/graduate-visa",
        "/uk-family-visa",
        "/find-a-visa-application-centre",
        "/guidance/visa-decision-waiting-times-applications-outside-the-uk",
        "/government/publications/skilled-worker-visa-shortage-occupations/skilled-worker-visa-shortage-occupations",
      ]

    pages_of_interest.each do |path|
      guide["base_path"] = path
      stub_content_store_has_item(guide["base_path"], guide.to_json)
      visit guide["base_path"]

      assert page.has_css?(".gem-c-intervention")
      assert page.has_link?("Take part in user research (opens in a new tab)", href: "https://surveys.publishing.service.gov.uk/s/0DZCPX/")
    end
  end

  test "Visa test recruitment banner is not displayed on all pages" do
    guide = GovukSchemas::Example.find("guide", example_name: "guide")
    guide["base_path"] = "/nothing-to-see-here"
    stub_content_store_has_item(guide["base_path"], guide.to_json)
    visit guide["base_path"]

    assert_not page.has_css?(".gem-c-intervention")
    assert_not page.has_link?("Take part in user research", href: "https://surveys.publishing.service.gov.uk/s/0DZCPX/")
  end
end
