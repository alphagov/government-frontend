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
    assert page.has_text?("As with the core Chevening Scheme this fellowship is an open competition. Applications from eligible countries will be assessed against each other by an independent panel and the top application for each topic received will be awarded.")
  end

  test "renders first published, from and part of in metadata and document footer" do
    setup_and_visit_content_item('world_location_news_article')

    assert_has_published_dates("Published 24 November 2015")
    assert_footer_has_published_dates("Published 24 November 2015")
  end

  test "renders translation links when there is more than one translation" do
    setup_and_visit_content_item("world_location_news_article_with_multiple_translations")

    assert page.has_css?(".gem-c-translation-nav")
    assert page.has_css?(".gem-c-translation-nav__list-item")

    assert page.has_content?(:all, "English हिंदी 日本語 中文 中文")

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
