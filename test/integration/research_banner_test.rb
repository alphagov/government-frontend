require "test_helper"

class ResearchBannerTest < ActionDispatch::IntegrationTest
  test "Cost of living survey banner is displayed on pages of interest" do
    guide = GovukSchemas::Example.find("guide", example_name: "guide")

    pages_of_interest = %w[
      /cost-of-living
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
      visit path

      assert page.has_css?(".gem-c-intervention")
      assert page.has_link?("Take part in user research (opens in a new tab)", href: "https://gdsuserresearch.optimalworkshop.com/treejack/ct80d1d6")
    end
  end

  test "Cost of living recruitment banner is not displayed on all pages" do
    guide = GovukSchemas::Example.find("guide", example_name: "guide")
    guide["base_path"] = "/universal-credit/changes-of-circumstances"
    stub_content_store_has_item(guide["base_path"], guide.to_json)
    visit "/universal-credit/changes-of-circumstances"

    assert_not page.has_css?(".gem-c-intervention")
    assert_not page.has_link?("Take part in user research (opens in a new tab)", href: "https://surveys.publishing.service.gov.uk/s/XS2YWV/")
  end
end
