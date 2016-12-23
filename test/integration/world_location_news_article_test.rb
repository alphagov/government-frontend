require 'test_helper'

class WorldLocationNewsArticleTest < ActionDispatch::IntegrationTest
  test "world location news article renders title, description and body" do
    setup_and_visit_content_item("world_location_news_article")

    assert page.has_css?(
      "meta[name='description'][content='Chevening Secretariat announces the Chevening/British Library Fellowship']",
      visible: false
    )

    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
    assert_has_component_govspeak(@content_item["details"]["body"])
  end

  test "renders first published, from and part of in metadata and document footer" do
    setup_and_visit_content_item('world_location_news_article')

    from = "<a href=\"/government/world/organisations/british-high-commission-nairobi\">British High Commission Nairobi</a>"
    part_of = "<a href=\"/government/world/organisations/british-high-commission-nairobi\">Kenya</a>"

    assert_has_component_metadata_pair("first_published", "24 November 2015")
    assert_has_component_document_footer_pair("published", "24 November 2015")

    assert_has_component_metadata_pair("from", [from])
    assert_has_component_document_footer_pair("from", [from])

    assert_has_component_metadata_pair("part_of", [part_of])
    assert_has_component_document_footer_pair("part_of", [part_of])
  end

  test "renders translation links when there is more than one translation" do
    setup_and_visit_content_item("world_location_news_article_with_multiple_translations")

    assert page.has_css?("div[class='available-languages']")

    assert page.has_css?("li[class='translation']")

    assert page.has_content?("English हिंदी 日本語 中文 中文")

    assert page.has_link?("", "changes-to-secure-english-language-test-providers-for-uk-visas.hi")
  end
end
