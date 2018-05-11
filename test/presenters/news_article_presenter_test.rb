require 'presenter_test_helper'

class NewsArticlePresenterTest
  class NewsArticlePresenterTestCase < PresenterTestCase
    attr_accessor :example_schema_name

    def schema_name
      "news_article"
    end
  end

  class PresentedNewsArticleTest < NewsArticlePresenterTestCase
    test 'is linkable' do
      assert presented_item.is_a?(ContentItem::Linkable)
    end

    test 'is updatable' do
      assert presented_item.is_a?(ContentItem::Updatable)
    end

    test 'is withdrawable' do
      assert presented_item.is_a?(ContentItem::Withdrawable)
    end

    test 'is shareable' do
      assert presented_item.is_a?(ContentItem::Shareable)
    end

    test 'includes political' do
      assert presented_item.is_a?(ContentItem::Political)
    end

    test 'presents a description' do
      assert_equal schema_item['description'], presented_item.description
    end

    test 'presents a body' do
      assert_equal schema_item['details']['body'], presented_item.body
    end

    test 'presents a readable first published date' do
      assert_equal '25 December 2016', presented_item.published
    end

    test 'presents the locale' do
      assert_equal schema_item['locale'], presented_item.locale
    end

    test 'has structured data' do
      item = { "links" => { "primary_publishing_organisation" => [{ "title" => "Ministry of Magic", "base_path" => "/government/organisations/magic" }] } }

      structured_data = presented_item("news_article", item).structured_data

      assert_equal "https://www.test.gov.uk/government/news/christmas-2016-prime-ministers-message", structured_data["mainEntityOfPage"]["@id"]
      assert_equal "2016-12-25T00:15:02.000+00:00", structured_data["datePublished"]
      assert_equal "Ministry of Magic", structured_data["author"]["name"]
      assert_equal "https://www.test.gov.uk/government/organisations/magic", structured_data["author"]["url"]
    end
  end

  class HistoryModePresentedNewsArticle < NewsArticlePresenterTestCase
    def example_schema_name
      "news_article_history_mode"
    end

    test 'presents historically political' do
      assert presented_item(example_schema_name).historically_political?
    end
  end

  class TranslatedPresentedNewsArticle < NewsArticlePresenterTestCase
    def example_schema_name
      "news_article_news_story_translated_arabic"
    end

    test 'presents the locale as the translated item locale' do
      assert_equal 'ur', presented_item(example_schema_name).locale
    end
  end
end
