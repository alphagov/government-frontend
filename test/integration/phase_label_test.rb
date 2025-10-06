require "test_helper"

class PhaseLabelTest < ActionDispatch::IntegrationTest
  test "Alpha phase label is displayed for a Case Study in phase 'alpha'" do
    worldwide_organisation = GovukSchemas::Example.find("worldwide_organisation", example_name: "worldwide_organisation")
    worldwide_organisation["phase"] = "alpha"

    stub_content_store_has_item("/world/uk-embassy-in-country", worldwide_organisation.to_json)

    visit_with_cachebust "/world/uk-embassy-in-country"

    assert page.has_text?("alpha")
  end

  test "No phase label is displayed for a Content item without a phase field" do
    content_item = GovukSchemas::Example.find("worldwide_organisation", example_name: "worldwide_organisation")
    content_item.delete("phase")
    stub_content_store_has_item("/world/uk-embassy-in-country", content_item.to_json)

    visit_with_cachebust "/world/uk-embassy-in-country"

    assert_not page.has_text?("alpha")
  end
end
