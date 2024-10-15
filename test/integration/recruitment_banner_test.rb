require "test_helper"

class RecruitmentBannerTest < ActionDispatch::IntegrationTest
  def hmrc_banner_survey_url
    "https://survey.take-part-in-research.service.gov.uk/jfe/form/SV_74GjifgnGv6GsMC?Source=BannerList_HMRC_CCG_Compliance"
  end

  test "HMRC banner 29/08/2024 is displayed on detailed guides of interest" do
    detailed_guide = GovukSchemas::Example.find("detailed_guide", example_name: "detailed_guide")
    detailed_guide_paths = [
      "/guidance/voluntary-and-community-sector-organisations-who-can-give-you-extra-support",
      "/guidance/how-to-get-a-review-of-an-hmrc-decision",
      "/guidance/tax-disputes-alternative-dispute-resolution-adr",
    ]

    detailed_guide_paths.each do |path|
      detailed_guide["base_path"] = path
      stub_content_store_has_item(detailed_guide["base_path"], detailed_guide.to_json)
      visit detailed_guide["base_path"]

      assert page.has_css?(".gem-c-intervention")
      assert page.has_link?("Sign up to take part in user research (opens in a new tab)", href: hmrc_banner_survey_url)
    end
  end

  test "HMRC banner 29/08/2024 is displayed on document collections of interest" do
    document_collection = GovukSchemas::Example.find("document_collection", example_name: "document_collection")
    document_collection_paths = [
      "/government/collections/tax-compliance-detailed-information",
      "/government/collections/hm-revenue-and-customs-compliance-checks-factsheets",
    ]

    document_collection_paths.each do |path|
      document_collection["base_path"] = path
      stub_content_store_has_item(document_collection["base_path"], document_collection.to_json)
      visit document_collection["base_path"]

      assert page.has_css?(".gem-c-intervention")
      assert page.has_link?("Sign up to take part in user research (opens in a new tab)", href: hmrc_banner_survey_url)
    end
  end

  test "HMRC banner 29/08/2024 is displayed on guides of interest" do
    guide = GovukSchemas::Example.find("guide", example_name: "guide")
    guide_paths = [
      "/difficulties-paying-hmrc",
      "/tax-help",
      "/get-help-hmrc-extra-support",
      "/tax-appeals",
    ]

    guide_paths.each do |path|
      guide["base_path"] = path
      stub_content_store_has_item(guide["base_path"], guide.to_json)
      visit guide["base_path"]

      assert page.has_css?(".gem-c-intervention")
      assert page.has_link?("Sign up to take part in user research (opens in a new tab)", href: hmrc_banner_survey_url)
    end
  end

  test "HMRC banner 29/08/2024 is displayed on answer pages of interest" do
    answer = GovukSchemas::Example.find("answer", example_name: "answer")

    answer["base_path"] = "/tax-help"
    stub_content_store_has_item(answer["base_path"], answer.to_json)
    visit answer["base_path"]

    assert page.has_css?(".gem-c-intervention")
    assert page.has_link?("Sign up to take part in user research (opens in a new tab)", href: hmrc_banner_survey_url)
  end

  test "HMRC banner 29/08/2024 is not displayed on all pages" do
    detailed_guide = GovukSchemas::Example.find("detailed_guide", example_name: "detailed_guide")
    detailed_guide["base_path"] = "/nothing-to-see-here"
    stub_content_store_has_item(detailed_guide["base_path"], detailed_guide.to_json)
    visit detailed_guide["base_path"]

    assert_not page.has_css?(".gem-c-intervention")
  end

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
