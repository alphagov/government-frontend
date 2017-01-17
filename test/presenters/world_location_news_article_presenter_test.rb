require 'presenter_test_helper'

class WorldLocationNewsArticlePresenterTest
  class WorldLocationNewsArticlePresenterTestCase < PresenterTestCase
    attr_accessor :example_schema_name

    def format_name
      "world_location_news_article"
    end
  end

  class PresentedWorldLocationNewsArticleTest < WorldLocationNewsArticlePresenterTestCase
    test 'is linkable' do
      assert presented_item.is_a?(Linkable)
    end

    test 'is updatable' do
      assert presented_item.is_a?(Updatable)
    end

    test 'is withdrawable' do
      assert presented_item.is_a?(Withdrawable)
    end

    test 'is shareable' do
      assert presented_item.is_a?(Shareable)
    end

    test 'includes political' do
      assert presented_item.is_a?(Political)
    end

    test 'presents the format' do
      assert_equal schema_item['schema_name'], presented_item.format
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
      assert_equal @expected_translations, @presented_translations
    end
  end
end
