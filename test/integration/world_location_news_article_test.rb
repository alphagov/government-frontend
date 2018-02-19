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

    assert_has_published_dates("Published 24 November 2015")
    assert_footer_has_published_dates("Published 24 November 2015")
  end

  test "renders organisation and location links" do
    setup_and_visit_content_item('world_location_news_article')

    assert_has_publisher_metadata(metadata: {
      "From": {
        "British High Commission Nairobi":
          "/government/world/organisations/british-high-commission-nairobi"
      }
    })

    assert_has_related_navigation(
      section_name: "related-nav-world_locations",
      section_text: "World locations",
      links: { "Kenya": "/world/kenya/news" }
    )

    assert_has_link_to_finder(
      "More news articles",
      "/government/announcements",
      "departments[]" => "all",
      "announcement_filter_option" => "all",
      "topics[]" => "all",
    )
  end

  test "renders translation links when there is more than one translation" do
    setup_and_visit_content_item("world_location_news_article_with_multiple_translations")

    assert page.has_css?(".app-c-translation-nav")
    assert page.has_css?(".app-c-translation-nav__list-item")

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
    within ".app-c-banner" do
      assert page.has_text?("This was published under the 2010 to 2015 Conservative and Liberal Democrat coalition government")
    end
  end
end
