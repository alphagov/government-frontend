require "test_helper"

class RecruitmentBannerTest < ActionDispatch::IntegrationTest
  test "Cost of living survey banner is displayed on pages of interest" do
    guide = GovukSchemas::Example.find("guide", example_name: "guide")

    pages_of_interest = %w[
      /guidance/cost-of-living-payment
      /cost-living-help-local-council
      /benefits-calculators
      /the-warm-home-discount-scheme
      /universal-credit
      /universal-credit/eligibility
      /universal-credit/what-youll-get
      /universal-credit/how-to-claim
      /universal-credit/other-financial-support
      /universal-credit/contact-universal-credit
      /new-state-pension/what-youll-get
      /get-help-energy-bills
      /get-help-energy-bills/getting-discount-energy-bill
      /pension-credit
    ]

    pages_of_interest.each do |path|
      guide["base_path"] = path
      stub_content_store_has_item(guide["base_path"], guide.to_json)
      visit guide["base_path"]

      assert page.has_css?(".gem-c-intervention")
      assert page.has_link?("Take part in user research (opens in a new tab)", href: "https://s.userzoom.com/m/MSBDMTQ3MVM0NCAg")
    end
  end

  test "Cost of living recruitment banner is not displayed on all pages" do
    guide = GovukSchemas::Example.find("guide", example_name: "guide")
    guide["base_path"] = "/nothing-to-see-here"
    stub_content_store_has_item(guide["base_path"], guide.to_json)
    visit guide["base_path"]

    assert_not page.has_css?(".gem-c-intervention")
    assert_not page.has_link?("Take part in user research (opens in a new tab)", href: "https://s.userzoom.com/m/MSBDMTQ3MVM0NCAg")
  end
end