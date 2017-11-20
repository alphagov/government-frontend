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

  test "renders part of in metadata and document footer" do
    # FIXME: These links are moving
    skip
    setup_and_visit_content_item('speech-transcript')

    link1 = "<a href=\"/government/policies/government-transparency-and-accountability\">Government transparency and accountability</a>"
    link2 = "<a href=\"/government/policies/tax-evasion-and-avoidance\">Tax evasion and avoidance</a>"
    link3 = "<a href=\"/government/topical-events/anti-corruption-summit-london-2016\">Anti-Corruption Summit: London 2016</a>"
    assert_has_component_metadata_pair("part_of", [link1, link2, link3])
    assert_has_component_document_footer_pair("part_of", [link1, link2, link3])
  end
end
