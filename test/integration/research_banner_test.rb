require "test_helper"

class ResearchBannerTest < ActionDispatch::IntegrationTest
  test "EOL banner is on the Get benefits if you're nearing the end of life page" do
    answer = GovukSchemas::Example.find("answer", example_name: "answer")
    answer["base_path"] = "/benefits-end-of-life"
    stub_content_store_has_item(answer["base_path"], answer.to_json)
    visit answer["base_path"]

    assert page.has_css?(".gem-c-intervention")
    assert page.has_text?("Help improve this GOV.UK page")
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
