require "test_helper"

class NewsArticleTest < ActionDispatch::IntegrationTest
  test "news article renders title, description and body" do
    setup_and_visit_content_item("news_article")
    assert_has_component_government_navigation_active("News and communications")
    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
    assert page.has_text?("This year, the United Kingdom has had much to celebrate. Her Majesty The Queen celebrated her 90th birthday")
  end

  test "renders first published and from in metadata and document footer" do
    setup_and_visit_content_item("news_article")

    assert_has_publisher_metadata(
      published: "Published 25 December 2016",
      metadata: {
        "From": {
          "Prime Minister's Office, 10 Downing Street":
            "/government/organisations/prime-ministers-office-10-downing-street",
        },
      }
    )

    assert_footer_has_published_dates("Published 25 December 2016")
  end

  test "renders translation links when there is more than one translation" do
    setup_and_visit_content_item("news_article")

    assert page.has_css?(".gem-c-translation-nav")
    assert page.has_css?(".gem-c-translation-nav__list-item")
    assert page.has_link?("ردو", href: "/government/news/christmas-2016-prime-ministers-message.ur")
  end

  test "renders the lead image" do
    setup_and_visit_content_item("news_article")
    assert page.has_css?("img[src*='s465_Christmas'][alt='Christmas']")
  end

  test "renders history notice" do
    setup_and_visit_content_item("news_article_history_mode")

    within ".app-c-banner" do
      assert page.has_text?("This was published under the 2010 to 2015 Conservative and Liberal Democrat coalition government")
    end
  end
end
