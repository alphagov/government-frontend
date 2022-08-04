require "test_helper"

class RecruitmentBannerTest < ActionDispatch::IntegrationTest
  test "Tree test recruitment banner is displayed for any page tagged to Working, jobs and pensions" do
    @working_browse_page = {
      "content_id" => "123",
      "title" => "Self Assessment",
      "base_path" => "/browse/working/self-assessment",
    }

    guide = GovukSchemas::Example.find("guide", example_name: "guide")
    guide["links"]["mainstream_browse_pages"] = []
    guide["links"]["mainstream_browse_pages"] << @working_browse_page

    stub_content_store_has_item(guide["base_path"], guide.to_json)
    visit guide["base_path"]

    assert page.has_css?(".gem-c-intervention")
    assert page.has_link?("Take part in user research (opens in a new tab)", href: "https://GDSUserResearch.optimalworkshop.com/treejack/b3cu012d")
  end

  test "Tree test recruitment banner is not displayed unless page is tagged to a topic of interest" do
    @not_of_interest = {
      "content_id" => "123",
      "title" => "I am not interesting",
      "base_path" => "/browse/boring",
    }

    guide = GovukSchemas::Example.find("guide", example_name: "guide")
    guide["links"]["mainstream_browse_pages"] = []
    guide["links"]["mainstream_browse_pages"] << @not_of_interest
    stub_content_store_has_item(guide["base_path"], guide.to_json)
    visit_with_cachebust guide["base_path"]

    assert_not page.has_css?(".gem-c-intervention")
    assert_not page.has_link?("Take part in user research", href: "https://GDSUserResearch.optimalworkshop.com/treejack/b3cu012d")
  end

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
