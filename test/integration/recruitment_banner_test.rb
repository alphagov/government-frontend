require "test_helper"

class RecruitmentBannerTest < ActionDispatch::IntegrationTest
  test "AI banner 11/11/2024 is displayed on guides of interest" do
    guide_paths = [
      "/self-assessment-tax-returns",
      "/self-employed-records",
      "/expenses-if-youre-self-employed",
      "/first-company-accounts-and-return",
      "/capital-allowances",
      "/simpler-income-tax-cash-basis",
      "/capital-gains-tax",
      "/directors-loans",
      "/running-a-limited-company",
      "/introduction-to-business-rates",
      "/apply-for-business-rate-relief",
      "/tax-codes",
    ]

    content_item = GovukSchemas::Example.find("guide", example_name: "guide")

    guide_paths.each do |path|
      content_item["base_path"] = path
      stub_content_store_has_item(content_item["base_path"], content_item.to_json)
      visit content_item["base_path"]

      assert page.has_css?(".gem-c-intervention")
      assert page.has_link?("Sign up to take part in user research (opens in a new tab)", href: "https://survey.take-part-in-research.service.gov.uk/jfe/form/SV_2bggmg6xlelrO0S")
    end
  end

  test "AI banner 11/11/2024 is displayed on answers of interest" do
    answer_paths = [
      "/working-for-yourself",
      "/what-is-the-construction-industry-scheme",
      "/expenses-and-benefits-a-to-z",
      "/self-assessment-tax-return-forms",
      "/calculate-tax-on-company-cars",
      "/calculate-your-business-rates",
      "/stop-being-self-employed",
    ]

    content_item = GovukSchemas::Example.find("answer", example_name: "answer")

    answer_paths.each do |path|
      content_item["base_path"] = path
      stub_content_store_has_item(content_item["base_path"], content_item.to_json)
      visit content_item["base_path"]

      assert page.has_css?(".gem-c-intervention")
      assert page.has_link?("Sign up to take part in user research (opens in a new tab)", href: "https://survey.take-part-in-research.service.gov.uk/jfe/form/SV_2bggmg6xlelrO0S")
    end
  end

  test "AI banner 11/11/2024 is not displayed on all pages" do
    detailed_guide = GovukSchemas::Example.find("detailed_guide", example_name: "detailed_guide")
    detailed_guide["base_path"] = "/nothing-to-see-here"
    stub_content_store_has_item(detailed_guide["base_path"], detailed_guide.to_json)
    visit detailed_guide["base_path"]

    assert_not page.has_css?(".gem-c-intervention")
  end
end
