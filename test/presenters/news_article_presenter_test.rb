require 'presenter_test_helper'

class NewsArticlePresenterTest
  class PresentedNewsArticle < PresenterTestCase
    def format_name
      "news_article"
    end

    test 'presents the format' do
      assert_equal schema_item['format'], presented_item.format
    end
  end
end
