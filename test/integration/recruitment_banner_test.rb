require "test_helper"

class RecruitmentBannerTest < ActionDispatch::IntegrationTest
  test "HMRC banner 21/10/2024 is displayed on detailed guide of interest" do
    detailed_guide = GovukSchemas::Example.find("detailed_guide", example_name: "detailed_guide")

    detailed_guide["base_path"] = "/guidance/keeping-your-hmrc-login-details-safe"
    stub_content_store_has_item(detailed_guide["base_path"], detailed_guide.to_json)
    visit detailed_guide["base_path"]

    assert page.has_css?(".gem-c-intervention")
    assert page.has_link?("Sign up to take part in user research (opens in a new tab)", href: "https://survey.take-part-in-research.service.gov.uk/jfe/form/SV_74GjifgnGv6GsMC?Source=BannerList_HMRC_PAS_TAD")
  end

  test "HMRC banner 21/10/2024 is displayed on document collection of interest" do
    document_collection = GovukSchemas::Example.find("document_collection", example_name: "document_collection")

    document_collection["base_path"] = "/government/collections/hmrc-phishing-and-scams-detailed-information"
    stub_content_store_has_item(document_collection["base_path"], document_collection.to_json)
    visit document_collection["base_path"]

    assert page.has_css?(".gem-c-intervention")
    assert page.has_link?("Sign up to take part in user research (opens in a new tab)", href: "https://survey.take-part-in-research.service.gov.uk/jfe/form/SV_74GjifgnGv6GsMC?Source=BannerList_HMRC_PAS_TAD")
  end

  test "HMRC banner 21/10/2024 is not displayed on all pages" do
    detailed_guide = GovukSchemas::Example.find("detailed_guide", example_name: "detailed_guide")
    detailed_guide["base_path"] = "/nothing-to-see-here"
    stub_content_store_has_item(detailed_guide["base_path"], detailed_guide.to_json)
    visit detailed_guide["base_path"]

    assert_not page.has_css?(".gem-c-intervention")
  end
end
