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
    from = [
      "<a href=\"/government/organisations/prime-ministers-office-10-downing-street\">Prime Minister&#39;s Office, 10 Downing Street</a>",
      "<a href=\"/government/people/theresa-may\">The Rt Hon Theresa May MP</a>"
    ]

    assert_has_component_metadata_pair("first_published", "25 December 2016")
    assert_has_component_document_footer_pair("published", "25 December 2016")

    assert_has_component_metadata_pair("from", from)
    assert_has_component_document_footer_pair("from", from)
  end

  test "renders 'part of' in metadata and document footer" do
    setup_and_visit_content_item('news_article_government_response')

    part_of = "<a href=\"/government/policies/marine-environment\">Marine environment</a>"
    assert_has_component_metadata_pair("part_of", [part_of])
    assert_has_component_document_footer_pair("part_of", [part_of])
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
