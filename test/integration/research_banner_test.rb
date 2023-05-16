require "test_helper"

class ResearchBannerTest < ActionDispatch::IntegrationTest
  test "Cost of living survey banner is displayed on pages of interest" do
    guide = GovukSchemas::Example.find("guide", example_name: "guide")

    cost_living_banner_pages = %w[
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

    cost_living_banner_pages.each do |path|
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
    assert_not page.has_link?("Take part in user research (opens in a new tab)", href: "https://gdsuserresearch.optimalworkshop.com/treejack/ct80d1d6")
  end

  test "EOL banner is on the Get benefits if you're nearing the end of life page" do
    answer = GovukSchemas::Example.find("answer", example_name: "answer")
    answer["base_path"] = "/benefits-end-of-life"
    stub_content_store_has_item(answer["base_path"], answer.to_json)
    visit answer["base_path"]

    assert page.has_css?(".gem-c-intervention")
  end

  test "EOL banner is on the Personal Independence Payment (PIP) page" do
    answer = GovukSchemas::Example.find("guide", example_name: "guide")
    answer["base_path"] = "/pip/claiming-if-you-might-have-12-months-or-less-to-live"
    stub_content_store_has_item(answer["base_path"], answer.to_json)
    visit answer["base_path"]

    assert page.has_css?(".gem-c-intervention")
  end

  test "EOL banner is not on other pages" do
    schema = GovukSchemas::Schema.find(frontend_schema: "detailed_guide")
    random_content = GovukSchemas::RandomExample.new(schema:).payload
    stub_content_store_has_item(random_content["base_path"], random_content.to_json)
    visit random_content["base_path"]

    assert_not page.has_css?(".gem-c-intervention")
    assert_not page.has_link?("Take part in user research (opens in a new tab)", href: "https://forms.office.com/e/a0WvT73tCV")
  end
end
