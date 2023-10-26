require "test_helper"

class RecruitmentBannerTest < ActionDispatch::IntegrationTest
  test "Benefits user research banner is displayed on pages of interest" do
    guide = GovukSchemas::Example.find("guide", example_name: "guide")

    pages_of_interest =
      [
        "/disability-living-allowance-children",
        "/help-with-childcare-costs",
        "/financial-help-disabled",
        "/pip",
        "/blind-persons-allowance",
        "/dla-disability-living-allowance-benefit",
        "/carers-allowance",
        "/carers-credit",
        "/maternity-pay-leave",
        "/paternity-pay-leave",
        "/child-benefit",
        "/jobseekers-allowance",
        "/universal-credit",
        "/employment-support-allowance",
        "/benefits-calculators",
      ]

    pages_of_interest.each do |path|
      guide["base_path"] = path
      stub_content_store_has_item(guide["base_path"], guide.to_json)
      visit guide["base_path"]

      assert page.has_css?(".gem-c-intervention")
      assert page.has_link?("Take part in user research", href: "https://signup.take-part-in-research.service.gov.uk/home?utm_campaign=Content_History&utm_source=Hold_gov_to_account&utm_medium=gov.uk&t=GDS&id=16")
    end
  end

  test "User research banner is not displayed on all pages" do
    guide = GovukSchemas::Example.find("guide", example_name: "guide")
    guide["base_path"] = "/nothing-to-see-here"
    stub_content_store_has_item(guide["base_path"], guide.to_json)
    visit guide["base_path"]

    assert_not page.has_css?(".gem-c-intervention")
    assert_not page.has_link?("Sign up to take part in user research", href: "https://gov.uk")
  end
end
