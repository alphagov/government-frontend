require 'presenter_test_helper'

class WorldLocationNewsArticlePresenterTest
  class WorldLocationNewsArticlePresenterTestCase < PresenterTestCase
    attr_accessor :example_schema_name

    def schema_name
      "world_location_news_article"
    end
  end

  class PresentedWorldLocationNewsArticleTest < WorldLocationNewsArticlePresenterTestCase
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

    test 'presents the schema name' do
      assert_equal schema_item['schema_name'], presented_item.schema_name
    end

    test 'presents a description' do
      assert_equal schema_item['description'], presented_item.description
    end

    test 'presents a body' do
      assert_equal schema_item['details']['body'], presented_item.body
    end

    test 'presents a readable first published date' do
      assert_equal '24 November 2015', presented_item.published
    end

    test 'presents the locale' do
      assert_equal schema_item['locale'], presented_item.locale
    end

    test 'presents worldwide organisations as from' do
      assert_includes presented_item.from[0], schema_item['links']['worldwide_organisations'][0]['title']
    end

    test 'presents world locations as part_of' do
      assert_includes presented_item.part_of[0], schema_item['links']['world_locations'][0]['title']
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

  class HistoryModePresentedWorldLocationNewsArticle < WorldLocationNewsArticlePresenterTestCase
    def example_schema_name
      "world_location_news_article_history_mode"
    end

    test 'presents historically political' do
      assert presented_item(example_schema_name).historically_political?
    end
  end

  class TranslatedPresentedWorldLocationNewsArticle < WorldLocationNewsArticlePresenterTestCase
    def example_schema_name
      "world_location_news_article_translated"
    end

    test 'presents the locale as the translated item locale' do
      assert_equal 'pt', presented_item(example_schema_name).locale
    end
  end

  class MultipleTranslationsPresentedWorldLocationNewsArticle < WorldLocationNewsArticlePresenterTestCase
    def example_schema_name
      "world_location_news_article_with_multiple_translations"
    end

    setup do
      # sorted so assert compares like with like
      @expected_translations = schema_item(example_schema_name)["links"]["available_translations"].sort_by { |hash| hash["locale"] }
      @presented_translations = presented_item(example_schema_name).available_translations.sort_by { |hash| hash["locale"] }
    end

    test 'presents the translations' do
      assert_equal @expected_translations.first['locale'], @presented_translations.first[:locale]
      assert_equal @expected_translations.first['base_path'], @presented_translations.first[:base_path]
    end
  end
end
