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
    part_of = "<a href=\"/world/kenya\">Kenya</a>"

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

    refute page.has_link?("English")

    assert page.has_link?("हिंदी", href: "/government/world-location-news/changes-to-secure-english-language-test-providers-for-uk-visas.hi")
    assert page.has_link?("日本語", href: "/government/world-location-news/changes-to-secure-english-language-test-providers-for-uk-visas.ja")
    assert page.has_link?("中文", href: "/government/world-location-news/changes-to-secure-english-language-test-providers-for-uk-visas.zh")
    assert page.has_link?("中文", href: "/government/world-location-news/changes-to-secure-english-language-test-providers-for-uk-visas.zh-tw")
  end

  test "renders the lead image" do
    setup_and_visit_content_item("world_location_news_article")

    assert page.has_css?("img[src*='placeholder-a6e35fc15d4bfcc9d0781f3888dc548b39288f0fe10a65a4b51fef603540b0c5'][alt='placeholder']")
  end

  test "renders history notice" do
    setup_and_visit_content_item("world_location_news_article_history_mode")

    within ".history-notice" do
      assert page.has_text?("This was published under the 2010 to 2015 Conservative and Liberal Democrat coalition government")
    end
  end
end
