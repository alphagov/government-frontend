require "test_helper"

class CaseStudyTest < ActionDispatch::IntegrationTest
  test "random but valid items do not error" do
    assert_nothing_raised { setup_and_visit_random_content_item }
  end

  test "translated case study" do
    setup_and_visit_content_item("translated")

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])

    assert page.has_css?(".gem-c-translation-nav")
  end

  test "withdrawn case study" do
    setup_and_visit_content_item("archived")

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])

    within ".gem-c-notice" do
      assert page.has_text?("This case study was withdrawn"), "is withdrawn"
      assert page.has_text?("We’ve withdrawn this case study and published newer")
      assert page.has_css?("time[datetime='#{@content_item['withdrawn_notice']['withdrawn_at']}']")
    end
  end

  test "does not render with the single page notification button" do
    setup_and_visit_content_item("translated")
    assert_not page.has_css?(".gem-c-single-page-notification-button")
  end
end
