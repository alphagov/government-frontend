require "test_helper"

class RecruitmentBannerTest < ActionDispatch::IntegrationTest
  test "Recruitment Banner is displayed for any page tagged to Money and Tax" do
    @money_and_tax_browse_page = {
      "content_id" => "123",
      "title" => "Self Assessment",
      "base_path" => "/browse/tax/self-assessment",
    }

    guide = GovukSchemas::Example.find("guide", example_name: "guide")
    guide["links"]["mainstream_browse_pages"] = []
    guide["links"]["mainstream_browse_pages"] << @money_and_tax_browse_page

    stub_content_store_has_item(guide["base_path"], guide.to_json)
    visit guide["base_path"]

    assert page.has_css?(".gem-c-intervention")
    assert page.has_link?("Take part in user research (opens in a new tab)", href: "https://surveys.publishing.service.gov.uk/s/GY8Q11")
  end

  test "Recruitment Banner is displayed for any page tagged to Business and Self-employed" do
    @business_browse_page = {
      "content_id" => "123",
      "title" => "Self Assessment",
      "base_path" => "/browse/business",
    }

    guide = GovukSchemas::Example.find("guide", example_name: "guide")
    guide["links"]["mainstream_browse_pages"] = []
    guide["links"]["mainstream_browse_pages"] << @business_browse_page

    stub_content_store_has_item(guide["base_path"], guide.to_json)
    visit guide["base_path"]

    assert page.has_css?(".gem-c-intervention")
    assert page.has_link?("Take part in user research (opens in a new tab)", href: "https://surveys.publishing.service.gov.uk/s/GY8Q11")
  end

  test "Recruitment Banner is not displayed unless page is tagged to a topic of interest" do
    @not_of_interest = {
      "content_id" => "123",
      "title" => "I am not interesting",
      "base_path" => "/browse/boring",
    }

    guide = GovukSchemas::Example.find("guide", example_name: "guide")
    guide["links"]["mainstream_browse_pages"] = []
    guide["links"]["mainstream_browse_pages"] << @not_of_interest
    stub_content_store_has_item(guide["base_path"], guide.to_json)
    visit_with_cachebust guide["base_path"]

    assert_not page.has_css?(".gem-c-intervention")
    assert_not page.has_link?("Take part in user research", href: "https://surveys.publishing.service.gov.uk/s/GY8Q11")
  end
end
