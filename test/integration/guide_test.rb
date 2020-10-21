require "test_helper"

class GuideTest < ActionDispatch::IntegrationTest
  test "random but valid items do not error" do
    setup_and_visit_random_content_item
  end

  test "guide header and navigation" do
    setup_and_visit_content_item("guide")

    assert page.has_css?("title", visible: false, text: @content_item["title"])
    assert_has_component_title(@content_item["title"])

    assert page.has_css?("h1", text: @content_item["details"]["parts"].first["title"])
    assert page.has_css?(".gem-c-pagination")
    assert page.has_css?('.gem-c-print-link a[href$="/print"]')
  end

  test "draft access tokens are appended to part links within navigation" do
    setup_and_visit_content_item("guide", "?token=some_token")

    assert page.has_css?('.gem-c-contents-list a[href$="?token=some_token"]')
  end

  test "does not show part navigation, print link or part title when only one part" do
    setup_and_visit_content_item("single-page-guide")

    assert_not page.has_css?("h1", text: @content_item["details"]["parts"].first["title"])
    assert_not page.has_css?(".gem-c-print-link")
  end

  test "replaces guide title with part title if in a step by step and hide_chapter_navigation is true" do
    setup_and_visit_content_item("guide-with-step-navs-and-hide-navigation")
    title = @content_item["title"]
    part_title = @content_item["details"]["parts"][0]["title"]

    assert_not page.has_css?("h1", text: title)
    assert_has_component_title(part_title)
  end

  test "does not replace guide title if not in a step by step and hide_chapter_navigation is true" do
    setup_and_visit_content_item("guide-with-hide-navigation")
    title = @content_item["title"]
    part_title = @content_item["details"]["parts"][0]["title"]

    assert_has_component_title(title)
    assert_has_component_title(part_title)
  end

  test "shows correct title in a single page guide if in a step by step and hide_chapter_navigation is true" do
    setup_and_visit_content_item("single-page-guide-with-step-navs-and-hide-navigation")
    title = @content_item["title"]
    part_title = @content_item["details"]["parts"][0]["title"]

    assert_not page.has_css?("h1", text: title)
    assert_has_component_title(part_title)
  end

  test "does not show guide navigation and print link if in a step by step and hide_chapter_navigation is true" do
    setup_and_visit_content_item("guide-with-step-navs-and-hide-navigation")

    assert_not page.has_css?(".gem-c-pagination")
    assert_not page.has_css?(".gem-c-print-link")
  end

  test "shows guide navigation and print link if not in a step by step and hide_chapter_navigation is true" do
    setup_and_visit_content_item("guide-with-hide-navigation")

    assert page.has_css?(".gem-c-pagination")
    assert page.has_css?(".gem-c-print-link")
  end

  test "guides with no parts in a step by step with hide_chapter_navigation do not error" do
    setup_and_visit_content_item("no-part-guide-with-step-navs-and-hide-navigation")
    title = @content_item["title"]

    assert_has_component_title(title)
  end

  test "guides show the faq page schema" do
    setup_and_visit_content_item("guide")
    faq_schema = find_structured_data(page, "FAQPage")

    assert_equal faq_schema["@type"], "FAQPage"
    assert_equal faq_schema["headline"], "The national curriculum"

    q_and_as = faq_schema["mainEntity"]
    answers = q_and_as.map { |q_and_a| q_and_a["acceptedAnswer"] }

    chapter_titles = [
      "Overview",
      "Key stage 1 and 2",
      "Key stage 3 and 4",
      "Other compulsory subjects",
    ]
    assert_equal chapter_titles, (q_and_as.map { |q_and_a| q_and_a["name"] })

    guide_part_urls = [
      "https://www.test.gov.uk/national-curriculum",
      "https://www.test.gov.uk/national-curriculum/key-stage-1-and-2",
      "https://www.test.gov.uk/national-curriculum/key-stage-3-and-4",
      "https://www.test.gov.uk/national-curriculum/other-compulsory-subjects",
    ]
    assert_equal guide_part_urls, (q_and_as.map { |q_and_a| q_and_a["url"] })
    assert_equal guide_part_urls, (answers.map { |answer| answer["url"] })
  end

  test "guide chapters do not show the faq schema" do
    setup_and_visit_part_in_guide
    faq_schema = find_structured_data(page, "FAQPage")

    assert_nil faq_schema
  end

  def setup_and_visit_part_in_guide
    @content_item = get_content_example("guide").tap do |item|
      chapter_path = "#{item['base_path']}/key-stage-1-and-2"
      stub_content_store_has_item(chapter_path, item.to_json)
      visit_with_cachebust(chapter_path)
    end
  end
end
