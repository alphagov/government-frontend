require 'test_helper'

class SpeechTest < ActionDispatch::IntegrationTest
  test "renders title, description and body" do
    setup_and_visit_content_item('speech')

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
    assert_has_component_govspeak(@content_item["details"]["body"])
  end

  test "renders metadata and document footer, including speaker" do
    setup_and_visit_content_item('speech')

    assert_has_component_metadata_pair("first_published", "8 March 2016")
    link1 = "<a href=\"/government/organisations/department-of-energy-climate-change\">Department of Energy &amp; Climate Change</a>"
    link2 = "<a href=\"/government/people/andrea-leadsom\">The Rt Hon Andrea Leadsom MP</a>"
    assert_has_component_metadata_pair("from", [link1, link2])
    assert_has_component_document_footer_pair("from", [link1, link2])

    assert_has_component_metadata_pair("Location", @content_item["details"]["location"])
    assert_has_component_metadata_pair(
      "Delivered on",
      '<time datetime="2016-02-02T00:00:00+00:00">2 February 2016</time> (Original script, may differ from delivered version)'
    )
  end

  test "renders part of in metadata and document footer" do
    setup_and_visit_content_item('speech-transcript')

    link1 = "<a href=\"/government/policies/government-transparency-and-accountability\">Government transparency and accountability</a>"
    link2 = "<a href=\"/government/policies/tax-evasion-and-avoidance\">Tax evasion and avoidance</a>"
    link3 = "<a href=\"/government/topical-events/anti-corruption-summit-london-2016\">Anti-Corruption Summit: London 2016</a>"
    assert_has_component_metadata_pair("part_of", [link1, link2, link3])
    assert_has_component_document_footer_pair("part_of", [link1, link2, link3])
  end

  test "renders speaker without a profile as text in metadata" do
    setup_and_visit_content_item('speech-speaker-without-profile')

    link1 = "<a href=\"/government/organisations/prime-ministers-office-10-downing-street\">Prime Minister&#39;s Office, 10 Downing Street</a>"
    link2 = "<a href=\"/government/organisations/cabinet-office\">Cabinet Office</a>"
    speaker = "Her Majesty the Queen"
    assert_has_component_metadata_pair("from", [link1, link2, speaker])
    assert_has_component_document_footer_pair("from", [link1, link2, speaker])
  end
end
