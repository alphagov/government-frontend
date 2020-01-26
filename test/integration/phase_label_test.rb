require "test_helper"

class PhaseLabelTest < ActionDispatch::IntegrationTest
  test "Alpha phase label is displayed for a Case Study in phase 'alpha'" do
    case_study = GovukSchemas::Example.find("case_study", example_name: "case_study")
    case_study["phase"] = "alpha"

    stub_content_store_has_item("/government/case-studies/get-britain-building-carlisle-park", case_study.to_json)

    visit_with_cachebust "/government/case-studies/get-britain-building-carlisle-park"

    assert page.has_text?("alpha")
  end

  test "No phase label is displayed for a Content item without a phase field" do
    content_item = GovukSchemas::Example.find("case_study", example_name: "case_study")
    content_item.delete("phase")
    stub_content_store_has_item("/government/case-studies/get-britain-building-carlisle-park", content_item.to_json)

    visit_with_cachebust "/government/case-studies/get-britain-building-carlisle-park"

    assert_not page.has_text?("alpha")
  end
end
