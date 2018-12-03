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

    test 'presents the document\'s image if present' do
      assert_equal schema_item['details']['image'], presented_item.image
    end

    test 'presents the document\'s organisation\'s default_news_image if document\'s image is not present' do
      default_news_image = { 'url' => 'http://www.test.dev.gov.uk/default_news_image.jpg' }
      example = schema_item
      example['details'].delete('image')
      example['links'] = {
        'primary_publishing_organisation' => [
          'details' => {
            'default_news_image' => default_news_image
          }
        ]
      }
      presented_item = present_example(example)
      assert_equal default_news_image, presented_item.image
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
