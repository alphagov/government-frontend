require "test_helper"

class NewsArticleTest < ActionDispatch::IntegrationTest
  test "news article renders title, description and body" do
    setup_and_visit_content_item("news_article")
    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
    assert page.has_text?("This year, the United Kingdom has had much to celebrate. Her Majesty The Queen celebrated her 90th birthday")
  end

  test "renders first published and from in metadata and document footer" do
    setup_and_visit_content_item("news_article")

    assert_has_metadata({
      published: "25 December 2016",
      from: {
        "Prime Minister's Office, 10 Downing Street":
        "/government/organisations/prime-ministers-office-10-downing-street",
      },
    })
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

    within ".govuk-notification-banner__content" do
      assert page.has_text?("This was published under the 2010 to 2015 Conservative and Liberal Democrat coalition government")
    end
  end

  test "marks up government name correctly" do
    setup_and_visit_content_item("news_article_history_mode_translated_arabic")

    within ".govuk-notification-banner__content" do
      assert page.has_css?("span[lang='en'][dir='ltr']", text: "2022 to 2024 Sunak Conservative government")
    end
  end

  test "does not render with the single page notification button" do
    setup_and_visit_content_item("news_article")
    assert_not page.has_css?(".gem-c-single-page-notification-button")
  end
end
