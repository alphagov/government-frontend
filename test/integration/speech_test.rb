require 'test_helper'

class SpeechTest < ActionDispatch::IntegrationTest
  test "renders title, description and body" do
    setup_and_visit_content_item('speech')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
    assert_has_component_govspeak(@content_item["details"]["body"])
  end

  test "translated speech" do
    setup_and_visit_content_item('speech-translated')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
    assert page.has_css?('.app-c-translation-nav')
  end

  test "renders metadata and document footer, including speaker" do
    setup_and_visit_content_item('speech')

    within(".app-c-publisher-metadata") do
      within(".app-c-published-dates") do
        assert page.has_content?("Published 8 March 2016")
      end

      within(".app-c-publisher-metadata__other") do
        assert page.has_content?("From: Department of Energy & Climate Change and The Rt Hon Andrea Leadsom MP")
        assert page.has_link?("Department of Energy & Climate Change",
                              href: "/government/organisations/department-of-energy-climate-change")
        assert page.has_link?("The Rt Hon Andrea Leadsom MP",
                              href: "/government/people/andrea-leadsom")
      end
    end

    within(".app-c-important-metadata") do
      assert page.has_content?("Delivered on: 2 February 2016 (Original script, may differ from delivered version)")
      assert page.has_content?("Location: Women in Nuclear UK Conference, Church House Conference Centre, Dean's Yard, Westminster, London")
    end

    within(".content-bottom-margin .app-c-published-dates") do
      assert page.has_content?("Published 8 March 2016")
    end
  end

  test "renders related policy links" do
    setup_and_visit_content_item('speech-transcript')

    within(".app-c-related-navigation__nav-section[aria-labelledby='related-nav-policies']") do
      assert page.has_css?(".app-c-related-navigation__section-link", text: "Government transparency and accountability")
      assert page.has_link?("Government transparency and accountability", href: "/government/policies/government-transparency-and-accountability")
      assert page.has_css?(".app-c-related-navigation__section-link", text: "Tax evasion and avoidance")
      assert page.has_link?("Tax evasion and avoidance", href: "/government/policies/tax-evasion-and-avoidance")
    end
  end
end
