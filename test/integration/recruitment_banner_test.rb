require "test_helper"

class RecruitmentBannerTest < ActionDispatch::IntegrationTest
  test "Brand user research banner is displayed on pages of interest" do
    guide = GovukSchemas::Example.find("guide", example_name: "guide")

    pages_of_interest =
      [
        "/maternity-allowance",
        "/funeral-payments",
        "/disability-living-allowance-children",
        "/pension-credit",
      ]

    pages_of_interest.each do |path|
      guide["base_path"] = path
      stub_content_store_has_item(guide["base_path"], guide.to_json)
      visit guide["base_path"]

      assert page.has_css?(".gem-c-intervention")
      assert page.has_link?("Take part in user research", href: "https://forms.office.com/e/CkfCRwdLQj")
    end
  end

  test "Brand user research banner is not displayed on all pages" do
    guide = GovukSchemas::Example.find("guide", example_name: "guide")
    guide["base_path"] = "/nothing-to-see-here"
    stub_content_store_has_item(guide["base_path"], guide.to_json)
    visit guide["base_path"]

    assert_not page.has_css?(".gem-c-intervention")
    assert_not page.has_link?("Take part in user research", href: "https://forms.office.com/e/CkfCRwdLQj")
  end
end
