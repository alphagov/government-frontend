require "test_helper"

class GuideTest < ActionDispatch::IntegrationTest
  test "random but valid items do not error" do
    assert_nothing_raised { setup_and_visit_random_content_item }
  end

  test "guide header and navigation" do
    setup_and_visit_content_item("guide")

    assert page.has_css?("title", visible: false, text: @content_item["title"])
    assert_has_component_title(@content_item["title"])

    assert page.has_css?("h1", text: @content_item["details"]["parts"].first["title"])
    assert page.has_css?(".govuk-pagination")
    assert page.has_css?(".govuk-link.govuk-link--no-visited-state[href$='/print']", text: "View a printable version of the whole guide")
  end

  test "skip link in English" do
    setup_and_visit_content_item("guide")

    assert page.has_css?(".gem-c-skip-link", text: "Skip contents")
  end

  test "translated skip link" do
    setup_and_visit_content_item("guide", { "locale" => "cy" })

    assert page.has_css?(".gem-c-skip-link", text: "Sgipio cynnwys")
  end

  test "draft access tokens are appended to part links within navigation" do
    setup_and_visit_content_item_with_params("guide", "?token=some_token")

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

    assert_not page.has_css?(".govuk-pagination")
    assert_not page.has_css?(".govuk-link.govuk-link--no-visited-state[href$='/print']")
  end

  test "shows guide navigation and print link if not in a step by step and hide_chapter_navigation is true" do
    setup_and_visit_content_item("guide-with-hide-navigation")

    assert page.has_css?(".govuk-pagination")
    assert page.has_css?(".govuk-link.govuk-link--no-visited-state[href$='/print']", text: "View a printable version of the whole guide")
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
    assert_equal(chapter_titles, q_and_as.map { |q_and_a| q_and_a["name"] })

    guide_part_urls = [
      "https://www.test.gov.uk/national-curriculum",
      "https://www.test.gov.uk/national-curriculum/key-stage-1-and-2",
      "https://www.test.gov.uk/national-curriculum/key-stage-3-and-4",
      "https://www.test.gov.uk/national-curriculum/other-compulsory-subjects",
    ]
    assert_equal(guide_part_urls, q_and_as.map { |q_and_a| q_and_a["url"] })
    assert_equal(guide_part_urls, answers.map { |answer| answer["url"] })
  end

  test "guide chapters do not show the faq schema" do
    setup_and_visit_part_in_guide
    faq_schema = find_structured_data(page, "FAQPage")

    assert_nil faq_schema
  end

  # The schema config is in /config/machine_readable/how-to-vote.yml
  test "voting in the UK guide shows hard coded FAQ schema until voting closes" do
    when_voting_is_open do
      setup_and_visit_voting_guide

      faq_schema = find_structured_data(page, "FAQPage")
      q_and_as = faq_schema["mainEntity"]

      assert_equal faq_schema["@type"], "FAQPage"
      assert_equal faq_schema["headline"], "How to vote"
      assert_equal faq_schema["description"], "<p>You need to <a href=\"/register-to-vote?src=schema\">register to vote</a> before you can vote in UK elections or referendums.</p> <p>If you’re eligible, you can vote in person on the day of the election at a named polling station. You can also apply for a postal or proxy vote instead.</p> <p>There are elections and referendums in England, Scotland and Wales on 6 May 2021.</p>\n"

      assert_equal 10, q_and_as.count
    end
  end

  test "voting in the UK guide shows all chapters on a single page until voting closes" do
    when_voting_is_open do
      content_item = setup_and_visit_voting_guide
      part_titles = content_item["details"]["parts"].map { |part| part["title"] }

      part_titles.each do |part_title|
        assert page.has_css? "h1", text: part_title
      end
    end
  end

  test "voting in the UK guide shows autogenerated schemas after voting closes" do
    once_voting_has_closed do
      setup_and_visit_voting_guide

      faq_schema = find_structured_data(page, "FAQPage")

      assert_equal faq_schema["@type"], "FAQPage"
      assert_equal faq_schema["headline"], "The national curriculum" # the fake guide used in tests
    end
  end

  test "voting in the UK guide shows chapters on separate pages after voting closes" do
    once_voting_has_closed do
      content_item = setup_and_visit_voting_guide

      first_part = content_item["details"]["parts"].first
      assert_nothing_raised { assert_selector "h1", text: first_part["title"] }

      part_titles = content_item["details"]["parts"].drop(1).map { |part| part["title"] }
      part_titles.each do |part_title|
        assert_no_selector "h1", text: part_title
      end
    end
  end

  test "does not render with the single page notification button" do
    setup_and_visit_content_item("guide")
    assert_not page.has_css?(".gem-c-single-page-notification-button")
  end

  test "print link has GA4 tracking" do
    setup_and_visit_content_item("guide")

    expected_ga4_json = {
      event_name: "navigation",
      type: "print page",
      section: "Footer",
      text: "View a printable version of the whole guide",
    }.to_json

    assert page.has_css?("a[data-ga4-link='#{expected_ga4_json}']")
  end

  def once_voting_has_closed
    Timecop.freeze(Time.zone.local(2021, 5, 6, 22, 0, 0))
    yield
    Timecop.return
  end

  def when_voting_is_open
    Timecop.freeze(Time.zone.local(2021, 5, 6, 21, 59, 0))
    yield
    Timecop.return
  end

  def setup_and_visit_voting_guide
    @content_item = get_content_example("guide").tap do |item|
      item["base_path"] = "/how-to-vote"
      item["content_id"] = "9315bc67-33e7-42e9-8dea-e022f56dabfa"
      stub_content_store_has_item(item["base_path"], item.to_json)
      visit_with_cachebust(item["base_path"])
    end
  end

  def setup_and_visit_part_in_guide
    @content_item = get_content_example("guide").tap do |item|
      chapter_path = "#{item['base_path']}/key-stage-1-and-2"
      stub_content_store_has_item(chapter_path, item.to_json)
      visit_with_cachebust(chapter_path)
    end
  end
end
