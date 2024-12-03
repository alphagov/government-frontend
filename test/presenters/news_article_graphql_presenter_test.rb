require "presenter_test_helper"

class NewsArticleGraphqlPresenterTest
  class NewsArticleGraphqlPresenterTestCase < GraphqlPresenterTestCase
    attr_accessor :example_schema_name

    def schema_name
      "news_article"
    end
  end

  class PresentedNewsArticleGraphqlTest < NewsArticleGraphqlPresenterTestCase
    test "presents a description" do
      assert_equal "Summary of the news", presented_item.description
    end

    test "presents a body" do
      assert_equal "Some text", presented_item.body
    end

    test "presents a readable first published date" do
      assert_equal "25 December 2016", presented_item.published
    end

    test "presents the locale" do
      assert_equal "en", presented_item.locale
    end

    test "presents historically political" do
      assert presented_item.historically_political?
    end
  end
end
