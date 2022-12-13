require "test_helper"

class RecruitmentBannerTest < ActionDispatch::IntegrationTest
  test "Cost of living recruitment banner is displayed on pages of interest" do
    guide = GovukSchemas::Example.find("guide", example_name: "guide")

    pages_of_interest =
      [
        "/guidance/cost-of-living-payment",
        "/universal-credit",
        "/the-warm-home-discount-scheme",
        "/winter-fuel-payment",
        "/pay-self-assessment-tax-bill",
        "/universal-credit/eligibility",
        "/universal-credit/what-youll-get",
        "/universal-credit/how-to-claim",
        "/winter-fuel-payment/how-much-youll-get",
        "/government/publications/autumn-statement-2022-cost-of-living-support-factsheet/cost-of-living-support-factsheet",
        "/new-state-pension/what-youll-get",
        "/check-if-youre-eligible-for-warm-home-discount",
        "/universal-credit/other-financial-support",
        "/guidance/getting-the-energy-bills-support-scheme-discount",
        "/pension-credit",
        "/child-benefit",
      ]

    pages_of_interest.each do |path|
      guide["base_path"] = path
      stub_content_store_has_item(guide["base_path"], guide.to_json)
      visit guide["base_path"]

      assert page.has_css?(".gem-c-intervention")
      assert page.has_link?("Take part in user research (opens in a new tab)", href: "https://GDSUserResearch.optimalworkshop.com/treejack/cbd7a696cbf57c683cbb2e95b4a36c8a")
    end
  end

  test "Cost of living recruitment banner is not displayed on all pages" do
    guide = GovukSchemas::Example.find("guide", example_name: "guide")
    guide["base_path"] = "/nothing-to-see-here"
    stub_content_store_has_item(guide["base_path"], guide.to_json)
    visit guide["base_path"]

    assert_not page.has_css?(".gem-c-intervention")
    assert_not page.has_link?("Take part in user research", href: "https://GDSUserResearch.optimalworkshop.com/treejack/cbd7a696cbf57c683cbb2e95b4a36c8a")
  end
end
