require "test_helper"

class RecruitmentBannerTest < ActionDispatch::IntegrationTest
  test "Recruitment Banner is displayed for any page tagged to Working, jobs and pensions" do
    @working_browse_page = {
      "content_id" => "123",
      "title" => "Self Assessment",
      "base_path" => "/browse/working/self-assessment",
    }

    guide = GovukSchemas::Example.find("guide", example_name: "guide")
    guide["links"]["mainstream_browse_pages"] = []
    guide["links"]["mainstream_browse_pages"] << @working_browse_page

    stub_content_store_has_item(guide["base_path"], guide.to_json)
    visit guide["base_path"]

    assert page.has_css?(".gem-c-intervention")
    assert page.has_link?("Take part in user research (opens in a new tab)", href: "https://GDSUserResearch.optimalworkshop.com/treejack/61ec38b742396bc23d00104953ffb17d")
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
    assert_not page.has_link?("Take part in user research", href: "https://GDSUserResearch.optimalworkshop.com/treejack/61ec38b742396bc23d00104953ffb17d")
  end
end
