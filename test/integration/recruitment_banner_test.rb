require "test_helper"

class RecruitmentBannerTest < ActionDispatch::IntegrationTest
  test "MOD banner 20/08/2024 is displayed on page of interest" do
    detailed_guide = GovukSchemas::Example.find("detailed_guide", example_name: "detailed_guide")
    path = "/guidance/medals-campaigns-descriptions-and-eligibility"

    detailed_guide["base_path"] = path
    stub_content_store_has_item(detailed_guide["base_path"], detailed_guide.to_json)
    visit detailed_guide["base_path"]

    assert page.has_css?(".gem-c-intervention")
    assert page.has_link?("Take part in user research", href: "https://submit.forms.service.gov.uk/form/3874/give-feedback-on-medals-information-on-gov-uk/13188")
  end

  test "MOD banner 20/08/2024 is not displayed on all pages" do
    detailed_guide = GovukSchemas::Example.find("detailed_guide", example_name: "detailed_guide")
    detailed_guide["base_path"] = "/nothing-to-see-here"
    stub_content_store_has_item(detailed_guide["base_path"], detailed_guide.to_json)
    visit detailed_guide["base_path"]

    assert_not page.has_css?(".gem-c-intervention")
    assert_not page.has_link?("Take part in user research", href: "https://submit.forms.service.gov.uk/form/3874/give-feedback-on-medals-information-on-gov-uk/13188")
  end
end
