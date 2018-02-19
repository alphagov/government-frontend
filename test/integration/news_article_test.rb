require 'test_helper'

class NewsArticleTest < ActionDispatch::IntegrationTest
  test "news article renders title, description and body" do
    setup_and_visit_content_item("news_article")
    assert_has_component_government_navigation_active("announcements")
    assert_has_component_title(@content_item["title"])
    assert page.has_text?(@content_item["description"])
    assert_has_component_govspeak(@content_item["details"]["body"])
  end

  test "renders first published and from in metadata and document footer" do
    setup_and_visit_content_item("news_article")

    assert_has_publisher_metadata(
      published: "Published 25 December 2016",
      metadata: {
        "From": {
          "Prime Minister's Office, 10 Downing Street":
            "/government/organisations/prime-ministers-office-10-downing-street"
        }
      }
    )

    assert_footer_has_published_dates("Published 25 December 2016")

    assert_has_link_to_finder(
      "More news stories from Prime Minister's Office, 10 Downing Street",
      "/government/announcements",
      "departments[]" => "prime-ministers-office-10-downing-street",
      "announcement_filter_option" => "news-stories",
      "topics[]" => "all",
    )
  end


  test "renders policy links" do
    setup_and_visit_content_item('news_article_government_response')

    assert_has_related_navigation(
      section_name: "related-nav-policies",
      section_text: "Policy",
      links: { "Marine environment": "/government/policies/marine-environment" }
    )
  end

  test "renders translation links when there is more than one translation" do
    setup_and_visit_content_item("news_article")

    assert page.has_css?(".app-c-translation-nav")
    assert page.has_css?(".app-c-translation-nav__list-item")
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
